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
    
    private lazy var tableView = UITableView()
        .with {
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
                self.selectedHeightConstraint?.isActive = user == nil
                self.layoutIfNeeded()
            }
        )
        selectedUserView.user = user
    }
    
    func applySnapshot(_ snapshot: Snapshot) {
        dataSource.apply(snapshot)
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
        addSubviews(selectedUserView, tableView)
        selectedUserView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        selectedHeightConstraint = selectedUserView.heightAnchor.constraint(equalToConstant: 0)
        
        makeConstraints(inContainer: layoutMarginsGuide) {
            selectedUserView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            selectedUserView.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            selectedUserView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            
            tableView.topAnchor.constraint(equalTo: selectedUserView.bottomAnchor)
            tableView.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            tableView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            tableView.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchUsersRootView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
//        if cell.isSelected {
//            tableView.deselectRow(at: indexPath, animated: true)
//            onSelectUser(nil)
//            return nil
//        } else {
//            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//            let selectedID = dataSource.itemIdentifier(for: indexPath)
//            onSelectUser(selectedID)
//            return indexPath
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedID = dataSource.itemIdentifier(for: indexPath)
        onSelectUser(selectedID)
    }
}

extension NSDiffableDataSourceSnapshot: WithValue {}
