import Foundation
import Models
import struct Combine.AnyPublisher

struct RandomUserLoader {
    private func getRandomUsers(count: Int) -> AnyPublisher<[User], Never> {
        struct Result: Decodable {
            let results: [User]
    
            struct User: Decodable {
                let name: String
                let picture: Avatar
                let location: Location
                
                struct Avatar: Decodable {
                    let large: URL
                    let medium: URL
                    let thumbnail: URL
                }
                
                struct Location: Decodable {
                    let coordinates: Coordinates
                    
                    struct Coordinates: Decodable {
                        let latitude: Double
                        let longitude: Double
                    }
                }
            }
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: .randomUsers(count))
            .map(\.data)
            .decode(type: Result.self, decoder: JSONDecoder())
            .map(\.results)
            .map {
                $0.map {
                    Models.User(
                        name: $0.name,
                        avatarURL: $0.picture.thumbnail,
                        coordinate: Coordinate(
                            longitude: $0.location.coordinates.longitude,
                            latitude: $0.location.coordinates.longitude
                        )
                    )
                }
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func callAsFunction(_ count: Int = 15) -> AnyPublisher<[User], Never> {
        getRandomUsers(count: count)
    }
}

extension URL {
    static func randomUsers(_ count: Int) -> URL {
        URL(string: "https://randomuser.me/api/?results=\(count)")!
    }
}
