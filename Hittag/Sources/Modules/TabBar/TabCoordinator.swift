import ModuleArchitecture

final class TabCoordinator: Coordinator<TabPresenterType>, TabCoordinatorType {

    let viewController: ViewControllerType
    private let feedModule: FeedModuleType
    private let cameraModule: CameraModuleType

    init(feedModule: FeedModuleType,
         cameraModule: CameraModuleType,
         presenter: TabPresenterType,
         viewController: TabViewControllerType) {

        self.feedModule = feedModule
        self.cameraModule = cameraModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    override func start() {
        super.start()
        
        let feedCoordinator = self.feedModule.createCoordinator()
        let cameraCoordinator = self.cameraModule.createCoordinator(listener: self.presenter)
        
        let viewControllers = [
            feedCoordinator.viewController.asViewController(),
            cameraCoordinator.viewController.asViewController()
        ]
        
        (self.viewController.asViewController() as? UITabBarController)?.setViewControllers(viewControllers, animated: false)
        
        feedCoordinator.start()
        cameraCoordinator.start()
        self.attach(feedCoordinator)
        self.attach(cameraCoordinator)
    }
}
