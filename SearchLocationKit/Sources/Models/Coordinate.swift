public struct Coordinate {
    public let longitude: Double
    public let latitude: Double
    
    public static let zero = Coordinate(longitude: .zero, latitude: .zero)
    
    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}
