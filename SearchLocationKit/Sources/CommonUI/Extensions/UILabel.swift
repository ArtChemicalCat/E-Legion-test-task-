import UIKit
import Common

public extension UILabel {
    @discardableResult
    func withTextStyle(_ style: UIFont.TextStyle) -> Self {
        with { $0.font = .preferredFont(forTextStyle: style) }
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        with { $0.textColor = color }
    }
}
