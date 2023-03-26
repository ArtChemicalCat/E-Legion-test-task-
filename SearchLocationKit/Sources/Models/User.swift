import struct Foundation.URL
import struct Foundation.UUID
import Common

public struct User: Identifiable {
    public let name: String
    public let id: String
    public let avatarURL: URL?
    public let coordinate: Coordinate
    public let locationName: String
    
    public init(
        name: String,
        id: String,
        avatarURL: URL?,
        coordinate: Coordinate,
        locationName: String
    ) {
        self.name = name
        self.id = id
        self.avatarURL = avatarURL
        self.coordinate = coordinate
        self.locationName = locationName
    }
}

extension User: WithValue {}
