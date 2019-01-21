import ModuleArchitecture

final class TabCoordinator: Coordinator<TabPresenterType>, TabCoordinatorType {

    let viewController: ViewControllerType
    private let feedModule: FeedModuleType

    init(feedModule: FeedModuleType, presenter: TabPresenterType, viewController: TabViewControllerType) {

        self.feedModule = feedModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    override func start() {
        super.start()
        
        let feedCoordinator = self.feedModule.createCoordinator()
        
        let viewControllers = [
            feedCoordinator.viewController.asViewController()
        ]
        
        (self.viewController.asViewController() as? UITabBarController)?.setViewControllers(viewControllers, animated: false)
        
        feedCoordinator.start()
        self.attach(feedCoordinator)
    }
}
