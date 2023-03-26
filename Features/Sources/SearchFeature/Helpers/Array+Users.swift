import Models

extension Array where Element == User {
    func sortedByDistance(to location: Coordinate?) -> Self {
        guard let location else { return self }
        return sorted {
            $0.coordinate.distance(to: location) < $1.coordinate.distance(to: location)
        }
    }
}
