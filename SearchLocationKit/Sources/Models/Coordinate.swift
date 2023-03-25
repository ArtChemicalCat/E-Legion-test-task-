import CoreLocation

public struct Coordinate: Equatable {
    public let longitude: Double
    public let latitude: Double
    
    public static let zero = Coordinate(longitude: .zero, latitude: .zero)
    
    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    public func distance(to coordinate: Coordinate) -> Double {
        let fromCoordinate = CLLocation(
            latitude: latitude,
            longitude: longitude
        )
        let toCoordinate = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        return toCoordinate.distance(from: fromCoordinate)
    }
}
