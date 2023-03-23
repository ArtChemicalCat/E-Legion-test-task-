import CoreLocation
import Common
import Models
import class Combine.CurrentValueSubject

public class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Properties
    public typealias LocationPublisher = CurrentValueSubject<Coordinate, Never>
    public let shared = LocationManager()
    
    private lazy var manager = CLLocationManager()
        .with {
            $0.requestWhenInUseAuthorization()
            $0.delegate = self
        }
    
    public let currentLocation = LocationPublisher(.zero)
    
    // MARK: - Initialiser
    public override init() {
        super.init()
        manager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation.send(
            Coordinate(
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude
            )
        )
    }
}
