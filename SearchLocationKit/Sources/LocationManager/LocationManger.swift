import CoreLocation
import Common
import Models

public class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Properties
    private lazy var manager = CLLocationManager()
        .with {
            $0.requestWhenInUseAuthorization()
            $0.delegate = self
        }
    
    @Published
    public private(set) var currentLocation: Coordinate?
    public static let shared = LocationManager()
    
    // MARK: - Initialiser
    public override init() {
        super.init()
        manager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = Coordinate(
            longitude: location.coordinate.longitude,
            latitude: location.coordinate.latitude
        )
    }
}
