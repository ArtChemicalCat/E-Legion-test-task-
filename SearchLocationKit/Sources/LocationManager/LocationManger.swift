import CoreLocation
import Combine
import Common
import Models

public class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Properties
    private lazy var manager = CLLocationManager()
        .with {
            $0.requestWhenInUseAuthorization()
            $0.delegate = self
        }
    
    private let geocoder = CLGeocoder()
    
    @Published public private(set) var currentLocation: Coordinate?
    @Published public private(set) var locationName: String?
    
    public static let shared = LocationManager()
    
    // MARK: - Initialiser
    public override init() {
        super.init()
        manager.startUpdatingLocation()
    }
    
    public func locationName(for coordinate: Coordinate) -> AnyPublisher<String?, Never> {
        let subject = PassthroughSubject<String?, Never>()
        geocoder.reverseGeocodeLocation(
            .init(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        ) { placemarks, _ in
            guard let placemark = placemarks?.first else { return }
            subject.send(placemark.name)
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let coordinates = Coordinate(
            longitude: location.coordinate.longitude,
            latitude: location.coordinate.latitude
        )
        
        if locationName == nil {
            locationName(for: coordinates)
                .assign(to: &$locationName)
        }

        currentLocation = coordinates
    }
}
