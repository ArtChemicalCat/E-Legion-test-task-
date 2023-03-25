import struct Foundation.URL
import struct Foundation.UUID

public struct User: Identifiable {
    public let name: String
    public let id: String
    public let avatarURL: URL?
    public let coordinate: Coordinate
    
    public init(
        name: String,
        id: String,
        avatarURL: URL?,
        coordinate: Coordinate
    ) {
        self.name = name
        self.id = id
        self.avatarURL = avatarURL
        self.coordinate = coordinate
    }
}
