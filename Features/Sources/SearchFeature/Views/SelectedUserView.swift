import UIKit
import CommonUI
import Models

final class SelectedUserView: UIView {
    // MARK: - Views
    private let nameLabel = UILabel()
        .withTextStyle(.title1)
    
    private let locationLabel = UILabel()
        .withTextStyle(.body)
        .with { $0.numberOfLines = .zero }
    
    private let avatarImage = UIImageView()
        .set(width: avatarSize, height: avatarSize)
        .with {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = avatarSize / 2
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
            nameLabel.trailingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: -singleOffset)
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: oneAndHalfOffset)
            locationLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        }
    }
}

// MARK: - Constants
private let avatarSize = 100.0
