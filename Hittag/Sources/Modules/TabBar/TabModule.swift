import ModuleArchitecture

final class TabModule: Module, TabModuleType {

    private let feedModule: FeedModuleType
    
    init(feedModule: FeedModuleType) {
        self.feedModule = feedModule
    }
    
    func createCoordinator() -> TabCoordinatorType {

        let presenter = TabPresenter()
        let viewController = TabViewController()
        let coordinator = TabCoordinator(feedModule: self.feedModule,
                                         presenter: presenter,
                                         viewController: viewController)
        viewController.listener = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
