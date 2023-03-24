import UIKit

final class SearchUsersViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: SearchUsersViewModel
    
    // MARK: - Initialisers
    init(viewModel: SearchUsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
