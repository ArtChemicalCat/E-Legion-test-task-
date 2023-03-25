import UIKit
import Models
import Common

final class SearchUsersRootView: UIView {
    // MARK: - Types
    enum Section { case main }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, User.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User.ID>
    
    typealias UserDataProvider = (User.ID) -> (user: User, distance: String)?
    
    // MARK: - Views
    private lazy var tableView = UITableView()
        .with {
            $0.allowsMultipleSelection = false
            $0.separatorColor = .clear
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.rowHeight = UITableView.automaticDimension
            $0.register(UserCell.self)
        }

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
    func applySnapshot(_ snapshot: Snapshot) {
        dataSource.apply(snapshot)
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
        addSubview(tableView)
        tableView.pin(to: layoutMarginsGuide)
    }
}

// MARK: - UITableViewDelegate
extension SearchUsersRootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        if cell.isSelected {
            tableView.deselectRow(at: indexPath, animated: true)
            onSelectUser(nil)
            return nil
        } else {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            let selectedID = dataSource.itemIdentifier(for: indexPath)
            onSelectUser(selectedID)
            return indexPath
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension NSDiffableDataSourceSnapshot: WithValue {}
