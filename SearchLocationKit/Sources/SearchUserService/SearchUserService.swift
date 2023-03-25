import class Foundation.Timer
import Combine
import LocationManager
import Models

public protocol SearchUserServiceProtocol {
    func requestUserLocations() -> AnyPublisher<[User], Error>
}

public final class SearchUserService: SearchUserServiceProtocol {
    private var users = CurrentValueSubject<[User], Error>([])

    private let getRandomUsers = RandomUserLoader()
    private var timer: Timer?
    private var subscriptions = Set<AnyCancellable>()
    
    public init() {}
    
    public func requestUserLocations() -> AnyPublisher<[User], Error> {
        startTimer()
        requestUsers()

        return users
            .eraseToAnyPublisher()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: true) { [unowned self] timer in
                let updatedUsers = users.value.withRandomlyShiftedCoordinates()
                users.send(updatedUsers)
            }
    }
    
    private func requestUsers() {
        getRandomUsers()
            .sink(
                receiveCompletion: { [weak self] in
                    if case .failure(let error) = $0 {
                        self?.users.send(completion: .failure(error))
                    }
                },
                receiveValue: { [weak self] in
                    self?.users.send($0) }
            )
            .store(in: &subscriptions)
    }
}

private extension Array where Element == User {
    func withRandomlyShiftedCoordinates() -> [User] {
        map { User(
            name: $0.name,
            id: $0.id,
            avatarURL: $0.avatarURL,
            coordinate: Coordinate(
                longitude: $0.coordinate.longitude + Double.random(in: -0.1...0.1),
                latitude: $0.coordinate.latitude + Double.random(in: -0.1...0.1)
            )
        )  }
    }
}
