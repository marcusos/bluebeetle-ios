import ModuleArchitecture

final class TabCoordinator: Coordinator<TabPresenterType>, TabCoordinatorType {

    let viewController: ViewControllerType
    private let feedModule: FeedModuleType
    private let cameraModule: CameraModuleType
    private let profileModule: ProfileModuleType

    init(feedModule: FeedModuleType,
         cameraModule: CameraModuleType,
         profileModule: ProfileModuleType,
         presenter: TabPresenterType,
         viewController: TabViewControllerType) {

        self.feedModule = feedModule
        self.cameraModule = cameraModule
        self.profileModule = profileModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    override func start() {
        super.start()
        
        let feedCoordinator = self.feedModule.createCoordinator()
        let cameraCoordinator = self.cameraModule.createCoordinator(listener: self.presenter)
        let profileCoordinator = self.profileModule.createCoordinator()
        
        let viewControllers = [
            feedCoordinator.viewController.asViewController(),
            cameraCoordinator.viewController.asViewController(),
            profileCoordinator.viewController.asViewController()
        ]
        
        (self.viewController.asViewController() as? UITabBarController)?.setViewControllers(viewControllers, animated: false)
        
        feedCoordinator.start()
        cameraCoordinator.start()
        profileCoordinator.start()
        self.attach(feedCoordinator)
        self.attach(cameraCoordinator)
        self.attach(profileCoordinator)
    }
}
