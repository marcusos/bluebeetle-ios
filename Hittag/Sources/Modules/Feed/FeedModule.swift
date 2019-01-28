import ModuleArchitecture

final class FeedModule: Module, FeedModuleType {

    private let feedRepository: FeedRepositoryType
    
    init(feedRepository: FeedRepositoryType) {
        self.feedRepository = feedRepository
    }
    
    func createCoordinator() -> FeedCoordinatorType {

        let presenter = FeedPresenter(feedRepository: self.feedRepository)
        let viewController = FeedViewController()
        let coordinator = FeedCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
