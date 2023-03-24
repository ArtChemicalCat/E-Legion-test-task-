import UIKit

public final class SearchUsersViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: SearchUsersViewModel
    
    // MARK: - Initialisers
    public init(viewModel: SearchUsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemMint
        viewModel.startRequestingUserLocations()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
