import Combine
import SearchUserService
import Models

public final class SearchUsersViewModel {
    // MARK: - Properties
    private let userLocationsService: SearchUserServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private var users = [User.ID: User]()
    
    @Published private(set) var selectedUser: User?
    @Published private(set) var snapshot = SearchUsersRootView.Snapshot()
        .with {
            $0.appendSections([.main])
        }

    // MARK: - Initialiser
    public init(userLocationsService: SearchUserServiceProtocol = SearchUserService()) {
        self.userLocationsService = userLocationsService
    }
    
    // MARK: - Methods
    func startRequestingUserLocations() {
        userLocationsService
            .requestUserLocations()
            .sink(
                receiveCompletion: {
                    print($0)
                },
                receiveValue: { [weak self] in
                    $0.forEach {
                        self?.users[$0.id] = $0
                    }
                    self?.updateSnapshot(with: $0)
                }
            )
            .store(in: &subscriptions)
        
    }
    
    func select(user: User) {
        selectedUser = user
    }
    
    func user(withID id: User.ID) -> User? {
        users[id]
    }
    
    // MARK: - Private Methods
    private func updateSnapshot(with users: [User]) {
        let presentedUserIDs = snapshot.itemIdentifiers
        let newUserIDs = Set(users.map(\.id)).subtracting(presentedUserIDs)
        
        snapshot.appendItems(Array(newUserIDs), toSection: .main)
        snapshot.reconfigureItems(presentedUserIDs)
    }
}
