import UIKit
import Models
import CommonUI

final class UserCell: UITableViewCell {
    private let nameLabel = UILabel()
        .withTextStyle(.title2)
    
    private let coordinates = UILabel()
        .withTextStyle(.body)

    var user: User? {
        didSet {
            guard let user else { return }
            coordinates.text = "\(user.coordinate.latitude) : \(user.coordinate.longitude)"
            nameLabel.text = user.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureBackground()
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureBackground() {
        layer.cornerRadius = 12
        backgroundColor = .secondarySystemBackground
    }
    
    private func makeLayout() {
        contentView.addSubviews(nameLabel, coordinates)
        contentView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinates.translatesAutoresizingMaskIntoConstraints = false

        makeConstraints(inContainer: contentView.layoutMarginsGuide) {
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            nameLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            nameLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            
            coordinates.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12)
            coordinates.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            coordinates.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
            coordinates.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }
}
