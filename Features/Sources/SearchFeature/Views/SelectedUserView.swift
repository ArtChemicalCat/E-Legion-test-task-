import UIKit
import CommonUI
import Models

final class SelectedUserView: UIView {
    // MARK: - Views
    let nameLabel = UILabel()
        .withTextStyle(.title1)
    
    let locationLabel = UILabel()
        .withTextStyle(.body)
        .with { $0.numberOfLines = .zero }
    
    let avatarImage = UIImageView()
        .set(width: 100, height: 100)
        .with {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 50
            $0.clipsToBounds = true
        }
    
    // MARK: - Properties
    var user: User? {
        didSet {
            avatarImage.setImage(from: user?.avatarURL)
            nameLabel.text = user?.name
            locationLabel.text = user?.locationName
        }
    }
    
    // MARK: - Initialisers
    init() {
        super.init(frame: .zero)
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI Setup
    private func makeLayout() {
        addSubviews(nameLabel, locationLabel, avatarImage)
        
        makeConstraints(inContainer: layoutMarginsGuide) {
            avatarImage.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            avatarImage.topAnchor.constraint(equalTo: $0.topAnchor)
            avatarImage.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
                .with { $0.priority = .defaultHigh }
            
            nameLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            nameLabel.trailingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: -8)
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12)
            locationLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        }
    }
}
