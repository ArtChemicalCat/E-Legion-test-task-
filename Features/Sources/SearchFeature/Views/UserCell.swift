import UIKit
import Models
import CommonUI

final class UserCell: UITableViewCell {
    struct ViewModel {
        let userName: String
        let avatarURL: URL?
        let distance: String
    }
    // MARK: - Views
    private let roundedRect = UIView()
        .withBackgroundColor(.systemFill)
        .with { $0.layer.cornerRadius = radiusMedium }
    
    private let avatarImage = UIImageView()
        .set(width: avatarSize, height: avatarSize)
        .with {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = radiusMedium
            $0.contentMode = .scaleAspectFill
        }
    
    private let nameLabel = UILabel()
        .withTextStyle(.title2)
    
    private let distanceLabel = UILabel()
        .withTextStyle(.body)
    
    // MARK: - Initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureBackground()
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    func accept(viewModel: ViewModel) {
        nameLabel.text = viewModel.userName
        distanceLabel.text = viewModel.distance
        avatarImage.setImage(from: viewModel.avatarURL)
    }
    
    // MARK: - UI Setup
    private func configureBackground() {
        selectedBackgroundView = UIView()
            .withBackgroundColor(.clear)
        backgroundColor = .clear
    }
    
    private func makeLayout() {
        let rectContainer = UILayoutGuide()

        contentView.addSubviews(roundedRect, avatarImage, nameLabel, distanceLabel)
        contentView.addLayoutGuide(rectContainer)
        contentView.layoutMargins = .init(
            top: oneAndHalfOffset,
            left: 0,
            bottom: oneAndHalfOffset,
            right: 0
        )
        roundedRect.pin(to: rectContainer, insets: .init(top: singleOffset, left: 0, bottom: singleOffset, right: 0))
        
        makeConstraints(inContainer: contentView.layoutMarginsGuide) {
            rectContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            rectContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            rectContainer.topAnchor.constraint(equalTo: contentView.topAnchor)
            rectContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            avatarImage.topAnchor.constraint(equalTo: roundedRect.topAnchor, constant: singleOffset)
            avatarImage.leadingAnchor.constraint(equalTo: roundedRect.leadingAnchor, constant: singleOffset)
            avatarImage.bottomAnchor.constraint(equalTo: roundedRect.bottomAnchor, constant: -singleOffset)
                .with { $0.priority = .defaultHigh }
            
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            nameLabel.leadingAnchor.constraint(equalTo:  avatarImage.trailingAnchor, constant: singleOffset)
            nameLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            
            distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: singleOffset)
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            distanceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        }
    }
}

// MARK: - Constants
private let avatarSize = 60.0
