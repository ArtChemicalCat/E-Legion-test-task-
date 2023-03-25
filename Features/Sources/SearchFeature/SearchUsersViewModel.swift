import Combine
import Foundation
import SearchUserService
import LocationManager
import Models

public final class SearchUsersViewModel {
    // MARK: - Properties
    private let userLocationsService: SearchUserServiceProtocol
    private let locationManager = LocationManager()
    private var subscriptions = Set<AnyCancellable>()

    private let distanceFormatter = LengthFormatter()
    
    private var currentLocation: Coordinate?
    private var users = [User.ID: User]()
    
    @Published private(set) var selectedUser: User?
    @Published private(set) var snapshot = SearchUsersRootView.Snapshot()
        .with { $0.appendSections([.main]) }

    // MARK: - Initialiser
    public init(userLocationsService: SearchUserServiceProtocol = SearchUserService()) {
        self.userLocationsService = userLocationsService
    }
    
    // MARK: - Methods
    func startRequestingUserLocations() {
        getCurrentLocation()
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
    
    func selectUser(id: User.ID?) {
        selectedUser = id == nil ? nil : users[id!]
        snapshot.reconfigureItems(users.map(\.key))
    }
    
    func provideData(for id: User.ID) -> (user: User, distance: String)? {
        guard let user = users[id],
              let distance = distanceToUser(with: id) else { return nil }
        
        return (user, distance)
    
        func distanceToUser(with id: User.ID) -> String? {
            guard let targetLocation = users[id]?.coordinate,
                  let selectedLocation = selectedUser?.coordinate ?? currentLocation else { return nil }
            
            return distanceFormatter
                .string(
                    fromValue: selectedLocation.distance(to: targetLocation),
                    unit: .meter
                )
        }
    }
    
    
    // MARK: - Private Methods
    private func getCurrentLocation() {
        locationManager
            .$currentLocation
            .removeDuplicates()
            .print()
            .assign(to: \.currentLocation, on: self)
            .store(in: &subscriptions)
    }
    
    private func updateSnapshot(with users: [User]) {
        let presentedUserIDs = snapshot.itemIdentifiers
        let newUserIDs = Set(users.map(\.id)).subtracting(presentedUserIDs)
        
        snapshot.appendItems(Array(newUserIDs), toSection: .main)
        snapshot.reconfigureItems(presentedUserIDs)
    }
}
