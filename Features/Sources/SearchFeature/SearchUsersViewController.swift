import UIKit
import Combine

public final class SearchUsersViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: SearchUsersViewModel
    private var rootView: SearchUsersRootView {
        view as! SearchUsersRootView
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialisers
    public init(viewModel: SearchUsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.startRequestingUserLocations()
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Override
    public override func loadView() {
        view = SearchUsersRootView(
            dataProvider: { [weak viewModel] in viewModel?.provideData(for: $0) },
            onSelectUser: { [weak viewModel] in viewModel?.selectUser(id: $0) }
        )
    }
    
    // MARK: - Methods
    private func bindToViewModel() {
        viewModel
            .$snapshot
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.rootView.applySnapshot($0)
                }
            )
            .store(in: &subscriptions)
        
        viewModel
            .$selectedUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.select(user: $0)
            }
            .store(in: &subscriptions)
        
    }
}
