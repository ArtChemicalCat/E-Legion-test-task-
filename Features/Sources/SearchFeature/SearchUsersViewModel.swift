import Combine
import Foundation
import SearchUserService
import LocationManager
import Models

public final class SearchUsersViewModel {
    // MARK: - Properties
    private let userLocationsService: SearchUserServiceProtocol
    private let locationManager = LocationManager.shared
    private var subscriptions = Set<AnyCancellable>()

    private let distanceFormatter = LengthFormatter()
        .with {
            $0.numberFormatter.maximumFractionDigits = .zero
            $0.numberFormatter.groupingSeparator = " "
        }

    private var users = [User.ID: User]()
    
    @Published private(set) var currentLocation: Coordinate?
    @Published private(set) var locationName: String?
    
    @Published private(set) var isLoading = true
    
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
            .combineLatest($currentLocation.setFailureType(to: Error.self))
            .sink(
                receiveCompletion: { print($0) },
                receiveValue: { [weak self] users, currentLocation in
                    self?.isLoading = users.isEmpty || currentLocation == nil
                    self?.users = users.reduce(into: [:]) {
                        guard $1.id != (self?.selectedUser?.id ?? "") else { return }
                        $0[$1.id] = $1
                    }
                    
                    self?.updateSnapshot()
                }
            )
            .store(in: &subscriptions)
    }
    
    func selectUser(id: User.ID?) {
        switch (id, selectedUser) {
        case let (id?, unselected?):
            users[unselected.id] = unselected
            selectedUser = users[id]
            users[id] = nil
        case let (id?, nil):
            selectedUser = users[id]
            users[id] = nil
        case let (nil, unselected?):
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
            $0.reconfigureItems(users.map(\.key))
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
            .sink { [weak self] in
                guard let location = $0 else { return }
                self?.currentLocation = location
            }
            .store(in: &subscriptions)
        
        locationManager
            .$locationName
            .removeDuplicates()
            .assign(to: &$locationName)
    }
    
    private func updateSnapshot() {
        guard let currentLocation else { return }
        let location = selectedUser?.coordinate ?? currentLocation
        
        snapshot = .init()
            .with {
                $0.appendSections([.main])
                $0.appendItems(
                    users
                        .map(\.value)
                        .sortedByDistance(to: location)
                        .filter { $0.id != selectedUser?.id ?? "" }
                        .map(\.id)
                )
                $0.reconfigureItems(users.map(\.key))
            }
    }
}
