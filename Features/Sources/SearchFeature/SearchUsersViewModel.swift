import Combine
import SearchUserService
import Models

public final class SearchUsersViewModel {
    // MARK: - Properties
    private let userLocationsService: SearchUserServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private(set) var selectedUser: User?
    @Published private(set) var users = [User]()

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
                receiveValue: {
                    print($0)
                }
            )
            .store(in: &subscriptions)
    }
    
    func select(user: User) {
        selectedUser = user
    }
}
