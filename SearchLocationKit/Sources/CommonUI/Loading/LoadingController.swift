import UIKit
import Common

public final class LoadingController: UIViewController {
    // MARK: - Views
    private let activityIndicator = UIActivityIndicatorView()
    
    private let loadingLabel = UILabel()
        .withTextStyle(.caption1)
        .withTextColor(.systemGray)
        .with {
            $0.textAlignment = .center
            $0.numberOfLines = .zero
            $0.text = "Загружаем дынные, пожалуйста подождите..."
        }
    
    // MARK: - LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
    
    // MARK: - UI Setup
    private func makeLayout() {
        view.addSubviews(activityIndicator, loadingLabel)
        
        makeConstraints(inContainer: view.layoutMarginsGuide) {
            activityIndicator.centerXAnchor.constraint(equalTo: $0.centerXAnchor)
            activityIndicator.centerYAnchor.constraint(equalTo: $0.centerYAnchor, constant: -50)
            
            loadingLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 50)
            loadingLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -50)
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16)
        }
    }
}

public extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        didMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
