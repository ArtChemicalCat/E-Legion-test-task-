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
        .with { $0.layer.cornerRadius = 12 }
    
    private let avatarImage = UIImageView()
        .set(width: 60, height: 60)
        .with {
            $0.clipsToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemGray3.cgColor
            $0.layer.cornerRadius = 8
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
        contentView.addSubviews(roundedRect, avatarImage, nameLabel, distanceLabel)
        contentView.layoutMargins = .init(top: 12, left: 0, bottom: 12, right: 0)
        let rectContainer = UILayoutGuide()
        contentView.addLayoutGuide(rectContainer)
        roundedRect.pin(to: rectContainer, insets: .init(top: 8, left: 0, bottom: 8, right: 0))
        
        makeConstraints(inContainer: contentView.layoutMarginsGuide) {
            rectContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            rectContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            rectContainer.topAnchor.constraint(equalTo: contentView.topAnchor)
            rectContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            avatarImage.topAnchor.constraint(equalTo: roundedRect.topAnchor, constant: 8)
            avatarImage.leadingAnchor.constraint(equalTo: roundedRect.leadingAnchor, constant: 8)
            avatarImage.bottomAnchor.constraint(equalTo: roundedRect.bottomAnchor, constant: -8)
                .with { $0.priority = .defaultHigh }
            
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            nameLabel.leadingAnchor.constraint(equalTo:  avatarImage.trailingAnchor, constant: 8)
            nameLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            
            distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            distanceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        }
    }
}
