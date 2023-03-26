import UIKit
import Common

public extension UIView {
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        with { $0.backgroundColor = color }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
