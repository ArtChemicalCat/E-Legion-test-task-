import UIKit
import Common

public extension UIView {
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        with { $0.backgroundColor = color }
    }
}
