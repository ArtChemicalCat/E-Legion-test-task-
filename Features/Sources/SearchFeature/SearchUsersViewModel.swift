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
        .with {
            $0.numberFormatter.maximumFractionDigits = .zero
            $0.numberFormatter.groupingSeparator = " "
        }
    
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
                    self?.users = $0.reduce(into: [:]) {
                        guard $1.id != (self?.selectedUser?.id ?? "") else { return }
                        $0[$1.id] = $1
                    }
                    
                    self?.updateSnapshot(with: $0)
                }
            )
            .store(in: &subscriptions)
    }
    
    func selectUser(id: User.ID?) {
        switch (id, selectedUser) {
        case let (id?, unselected?):
            snapshot.deleteItems([id])
            snapshot.appendItems([unselected.id])
            users[unselected.id] = unselected
            selectedUser = users[id]
            users[id] = nil
        case let (id?, nil):
            snapshot.deleteItems([id])
            selectedUser = users[id]
            users[id] = nil
        case let (nil, unselected?):
            snapshot.appendItems([unselected.id])
            users[unselected.id] = unselected
            selectedUser = nil
        default: break
        }

        snapshot = .init().with {
            $0.appendSections([.main])
            $0.appendItems(
                users
                    .map(\.value)
                    .sortedByDistance(to: selectedUser?.coordinate ?? currentLocation)
                    .map(\.id),
                toSection: .main
            )
        }
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
        let newUserIDs = Set(
            users
                .sortedByDistance(to: selectedUser?.coordinate ?? currentLocation)
                .filter { $0.id != (selectedUser?.id ?? "") }
                .map(\.id)
        ).subtracting(presentedUserIDs)
        
        snapshot.appendItems(Array(newUserIDs), toSection: .main)
        snapshot.reconfigureItems(presentedUserIDs)
    }
}

extension Array where Element == User {
    func sortedByDistance(to location: Coordinate?) -> Self {
        guard let location else { return self }
        return sorted {
            $0.coordinate.distance(to: location) < $1.coordinate.distance(to: location)
        }
    }
}
