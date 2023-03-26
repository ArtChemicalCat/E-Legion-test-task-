import UIKit
import CommonUI

final class YourLocationView: UIView {
    // MARK: - Views
    private let yourLocationLabel = UILabel()
        .withTextStyle(.title1)
        .with {
            $0.text = "Ближайшие к вам пользователи"
            $0.numberOfLines = 0
        }
    
    private let locationLabel = UILabel()
        .withTextStyle(.body)
    
    var locationName: String? {
        didSet {
            locationLabel.text = locationName
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
        addSubviews(yourLocationLabel, locationLabel)
        
        makeConstraints(inContainer: layoutMarginsGuide) {
            yourLocationLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            yourLocationLabel.topAnchor.constraint(equalTo: $0.topAnchor)
            yourLocationLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            
            locationLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor)
            locationLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
            locationLabel.topAnchor.constraint(equalTo: yourLocationLabel.bottomAnchor, constant: 12)
            locationLabel.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }
    
}

