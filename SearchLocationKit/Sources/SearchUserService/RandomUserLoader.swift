import Foundation
import Models
import struct Combine.AnyPublisher

struct RandomUserLoader {
    private func getRandomUsers(count: Int) -> AnyPublisher<[User], Error> {
        struct Result: Decodable {
            let results: [User]
    
            struct User: Decodable {
                let name: Name
                let id: ID
                let picture: Avatar
                let location: Location
                
                struct Name: Decodable {
                    let first: String
                    let last: String
                    
                    var full: String { first + " " + last }
                }
                
                struct ID: Decodable {
                    let value: String?
                }
                
                struct Avatar: Decodable {
                    let large: URL
                    let medium: URL
                    let thumbnail: URL
                }
                
                struct Location: Decodable {
                    let coordinates: Coordinates
                    
                    struct Coordinates: Decodable {
                        let latitude: String
                        let longitude: String
                    }
                }
            }
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: .randomUsers(count))
            .map(\.data)
            .decode(type: Result.self, decoder: JSONDecoder())
            .map(\.results)
            .map { users in
                users
                    .filter { $0.id.value != nil }
                    .map { user in
                        Models.User(
                            name: user.name.full,
                            id: user.id.value ?? "",
                            avatarURL: user.picture.thumbnail,
                            coordinate: Coordinate(
                                longitude: Double(user.location.coordinates.longitude) ?? 0,
                                latitude: Double(user.location.coordinates.longitude) ?? 0
                            )
                        )
                    }
            }
            .eraseToAnyPublisher()
    }
    
    func callAsFunction(_ count: Int = 15) -> AnyPublisher<[User], Error> {
        getRandomUsers(count: count)
    }
}

extension URL {
    static func randomUsers(_ count: Int) -> URL {
        URL(string: "https://randomuser.me/api/?results=\(count)")!
    }
}