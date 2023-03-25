import UIKit
import Models
import Common

final class SearchUsersRootView: UIView {
    // MARK: - Types
    enum Section { case main }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, User.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User.ID>
    
    typealias UserProvider = (User.ID) -> User?
    
    // MARK: - Views
    private lazy var tableView = UITableView()
        .with {
            $0.backgroundColor = .clear
            $0.rowHeight = UITableView.automaticDimension
            $0.register(UserCell.self)
        }

    // MARK: - Properties
    private lazy var dataSource = makeDataSource()
    private let getUser: UserProvider
    
    // MARK: - Initialiser
    init(userProvider: @escaping UserProvider) {
        self.getUser = userProvider
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
    
//    func configure(with users: [User]) {
//        guard !users.isEmpty else { return }
//        var snapshot =  dataSource.snapshot()
//        if snapshot.sectionIdentifiers.isEmpty {
//            snapshot.appendSections([.main])
//        }
//        
//        let presentedUsers = snapshot.itemIdentifiers
//        let usersToUpdate = users.filter { user in
//            presentedUsers.contains(where: { $0.id == user.id })
//        }
//        let newUsers = users.filter { user in
//            !presentedUsers.contains(where: { $0.id == user.id })
//        }
//        
//        dataSource.apply(
//            snapshot
//                .with {
//                    $0.reloadItems(usersToUpdate)
//                    $0.appendItems(newUsers, toSection: .main)
//                }
//        )
//    }
    
    // MARK: - DataSource
    private func makeDataSource() -> DataSource {
        DataSource(
            tableView: tableView,
            cellProvider: { [unowned self] tableView, indexPath, identifier in
                let cell: UserCell = tableView.dequeueCell(for: indexPath)
                cell.user = getUser(identifier)
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

extension NSDiffableDataSourceSnapshot: WithValue {}
