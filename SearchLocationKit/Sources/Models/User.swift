import struct Foundation.URL

public struct User {
    public let name: String
    public let avatarURL: URL?
    public let coordinate: Coordinate
    
    public init(name: String, avatarURL: URL?, coordinate: Coordinate) {
        self.name = name
        self.avatarURL = avatarURL
        self.coordinate = coordinate
    }
}
