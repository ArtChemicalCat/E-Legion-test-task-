import class Foundation.Timer
import Combine
import LocationManager
import Models

public protocol SearchUserServiceProtocol {
    func requestUserLocations() -> AnyPublisher<[User], Never>
}

public final class SearchUserService: SearchUserServiceProtocol {
    @Published private var users: [User]?

    private let timerPublisher = Timer.TimerPublisher(
        interval: 3,
        tolerance: 0.1,
        runLoop: .current,
        mode: .default
    )
    
    public func requestUserLocations() -> AnyPublisher<[User], Never> {
        let getRandomUsers = RandomUserLoader()
        getRandomUsers()
            .map(Optional.some)
            .assign(to: &$users)
        
        return timerPublisher
            .combineLatest($users)
            .compactMap(\.1)
            .map { $0.randomlyShiftCoordinates() }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper Functions
    private func getRandomLocation(relativeTo coordinate: Coordinate) -> Coordinate {
        Coordinate(
            longitude: coordinate.longitude + Double.random(in: -0.1...0.1),
            latitude: coordinate.latitude + Double.random(in: -0.1...0.1)
        )
    }
}

private extension Array where Element == User {
    func randomlyShiftCoordinates() -> [User] {
        map { User(
            name: $0.name,
            avatarURL: $0.avatarURL,
            coordinate: Coordinate(
                longitude: $0.coordinate.longitude + Double.random(in: -0.1...0.1),
                latitude: $0.coordinate.latitude + Double.random(in: -0.1...0.1)
            )
        )  }
    }
}
