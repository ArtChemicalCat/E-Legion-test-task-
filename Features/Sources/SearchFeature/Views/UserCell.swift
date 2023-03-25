import UIKit
import Models
import CommonUI

final class UserCell: UITableViewCell {
    struct ViewModel {
        let userName: String
        let distance: String
    }
    // MARK: - Views
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
    }
    
    // MARK: - UI Setup
    private func configureBackground() {
        selectedBackgroundView = UIView()
            .with {
                $0.layer.cornerRadius = 12
                $0.backgroundColor = .systemMint
            }
        layer.cornerRadius = 12
        backgroundColor = .clear
    }
    
    private func makeLayout() {
        contentView.addSubviews(nameLabel, distanceLabel)
        contentView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false

        makeConstraints(inContainer: contentView.layoutMarginsGuide) {
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            nameLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            nameLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            
            distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12)
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            distanceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
            distanceLabel.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }
}
