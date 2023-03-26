import UIKit
import CommonUI
import Models

final class SelectedUserView: UIView {
    // MARK: - Views
    let nameLabel = UILabel()
        .withTextStyle(.largeTitle)
    
    let locationLabel = UILabel()
        .withTextStyle(.body)
    
    // MARK: - Properties
    var user: User? {
        didSet {
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
        addSubviews(nameLabel, locationLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        makeConstraints(inContainer: layoutMarginsGuide) {
            nameLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            nameLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            nameLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12)
            locationLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            locationLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            locationLabel.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
                .with { $0.priority = .defaultHigh }
        }
    }
}
