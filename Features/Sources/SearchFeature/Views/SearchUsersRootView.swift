import UIKit
import Models
import Common
import CommonUI

final class SearchUsersRootView: UIView {
    // MARK: - Types
    enum Section { case main }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, User.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User.ID>
    
    typealias UserDataProvider = (User.ID) -> (user: User, distance: String)?
    
    // MARK: - Views
    private lazy var selectedUserView = SelectedUserView()
        .with {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(unselectUser)
                )
            )
        }
    
    private let yourLocationView = YourLocationView()
    
    private lazy var tableView = UITableView()
        .with {
            $0.showsVerticalScrollIndicator = false
            $0.separatorColor = .clear
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.rowHeight = UITableView.automaticDimension
            $0.register(UserCell.self)
        }

    // MARK: - Animated Constraints
    private var selectedHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Properties
    private lazy var dataSource = makeDataSource()
    private let provideData: UserDataProvider
    private let onSelectUser: (User.ID?) -> Void
    
    // MARK: - Initialiser
    init(
        dataProvider: @escaping UserDataProvider,
        onSelectUser: @escaping (User.ID?) -> Void
    ) {
        self.provideData = dataProvider
        self.onSelectUser = onSelectUser
        super.init(frame: .zero)
        makeLayout()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func select(user: User?) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.selectedUserView.alpha = user == nil ? 0 : 1
                self.yourLocationView.alpha = user == nil ? 1 : 0
            },
            completion: { _ in
                self.selectedUserView.isHidden = user == nil
                self.yourLocationView.isHidden = user != nil
            }
        )
        selectedUserView.user = user
    }
    
    func applySnapshot(_ snapshot: Snapshot) {
        dataSource.apply(snapshot)
    }
    
    func setCurrentLocation(name: String?) {
        yourLocationView.locationName = name
    }
    
    @objc private func unselectUser() {
        onSelectUser(nil)
    }

    // MARK: - DataSource
    private func makeDataSource() -> DataSource {
        DataSource(
            tableView: tableView,
            cellProvider: { [unowned self] tableView, indexPath, identifier in
                let cell: UserCell = tableView.dequeueCell(for: indexPath)
                
                if let data = provideData(identifier) {
                    let viewModel = UserCell.ViewModel(
                        userName: data.user.name,
                        avatarURL: data.user.avatarURL,
                        distance: data.distance
                    )
                    cell.accept(viewModel: viewModel)
                }
                return cell
            }
        )
    }

    // MARK: - UI Setup
    private func makeLayout() {
        addSubviews(selectedUserView, yourLocationView, tableView)
        
        makeConstraints(inContainer: layoutMarginsGuide) {
            yourLocationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            yourLocationView.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            yourLocationView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            yourLocationView.bottomAnchor.constraint(equalTo: tableView.topAnchor)

            selectedUserView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            selectedUserView.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            selectedUserView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            selectedUserView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
            
            tableView.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            tableView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            tableView.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchUsersRootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedID = dataSource.itemIdentifier(for: indexPath)
        onSelectUser(selectedID)
    }
}

extension NSDiffableDataSourceSnapshot: WithValue {}
