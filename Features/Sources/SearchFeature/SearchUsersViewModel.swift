import Foundation
import SearchUserService
import Models

public final class SearchUsersViewModel {
    // MARK: - Properties
    private let userLocationsService: SearchUserServiceProtocol
    
    @Published private(set) var selectedUser: User?
    @Published private(set) var users = [User]()
    
    // MARK: - Initialiser
    public init(userLocationsService: SearchUserServiceProtocol) {
        self.userLocationsService = userLocationsService
    }
    
    // MARK: - Methods
    func startRequestingUserLocations() {
        userLocationsService
            .requestUserLocations()
            .assign(to: &$users)
    }
    
    func select(user: User) {
        selectedUser = user
    }
}
