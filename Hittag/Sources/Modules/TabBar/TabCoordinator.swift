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
        
        let feedController = feedCoordinator.viewController.asViewController()
        let cameraController = cameraCoordinator.viewController.asViewController()
        let profileController = profileCoordinator.viewController.asViewController()
        
        let viewControllers = [feedController, cameraController, profileController]
        
        feedController.tabBarItem = UITabBarItem.feed
        cameraController.tabBarItem = UITabBarItem.camera
        profileController.tabBarItem = UITabBarItem.profile
        
        let tabController = (self.viewController.asViewController() as? UITabBarController)
        tabController?.setViewControllers(viewControllers, animated: false)
        tabController?.tabBar.barStyle = .default
        tabController?.tabBar.isTranslucent = false
        tabController?.tabBar.tintColor = .black
        
        feedCoordinator.start()
        cameraCoordinator.start()
        profileCoordinator.start()
        self.attach(feedCoordinator)
        self.attach(cameraCoordinator)
        self.attach(profileCoordinator)
    }
}

extension UITabBarItem {
    static var feed: UITabBarItem = {
        let image = UIImage(named: "feed")
        let selectedImage = UIImage(named: "feed-selected")
        let item = UITabBarItem(title: "Feed", image: image, selectedImage: selectedImage)
        return item
    }()
    
    static var camera: UITabBarItem = {
        let image = UIImage(named: "camera")
        let selectedImage = UIImage(named: "camera-selected")
        let item = UITabBarItem(title: "Camera", image: image, selectedImage: selectedImage)
        return item
    }()
    
    static var profile: UITabBarItem = {
        let image = UIImage(named: "profile")
        let selectedImage = UIImage(named: "profile-selected")
        let item = UITabBarItem(title: "Perfil", image: image, selectedImage: selectedImage)
        return item
    }()
}
