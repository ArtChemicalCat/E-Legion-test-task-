import UIKit

public extension UITableView {
    func register<Cell: UITableViewCell>(_ type: Cell.Type) {
        register(type, forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
    }
}
