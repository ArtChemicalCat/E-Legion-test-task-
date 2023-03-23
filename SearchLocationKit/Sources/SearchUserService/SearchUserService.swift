import Models

public protocol SearchUserServiceProtocol {
    func getNearbyUsers(relativeTo position: Coordinate) -> [User]
}

public final class SearchUserService: SearchUserServiceProtocol {
    public func getNearbyUsers(relativeTo position: Coordinate) -> [User] {
        fatalError()
    }
}
