import Foundation
import UIKit
import Cache

public final class ImageLoader {
    private let cache = Cache<URL, UIImage>()
    
    public static let shared = ImageLoader()
    
    public func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url else {
            completion(nil)
            return
        }
        if let cached = cache.value(for: url) {
            completion(cached)
            return
        }

        Task {
            let image = (try? Data(contentsOf: url))
                .flatMap(UIImage.init)
            image.map { cache.insert($0, for: url) }

            Task { @MainActor in completion(image) }
        }
    }
}

public extension UIImageView {
    func setImage(from url: URL?) {
        ImageLoader.shared.loadImage(from: url) { [weak self] in
            self?.image = $0
        }
    }
}
