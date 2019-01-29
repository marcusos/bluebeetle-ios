import ModuleArchitecture
import Parse

final class TabCoordinator: Coordinator<TabPresenterType>, TabCoordinatorType {

    let viewController: ViewControllerType
    private let feedModule: FeedModuleType
    private let cameraModule: CameraModuleType
    private let cameraTabModule: CameraTabModuleType
    private let profileModule: ProfileModuleType
    
    private var tabBarController: UITabBarController? {
        return self.viewController.asViewController() as? UITabBarController
    }
    
    private weak var cameraCoordinator: CameraCoordinatorType?

    init(feedModule: FeedModuleType,
         cameraModule: CameraModuleType,
         cameraTabModule: CameraTabModuleType,
         profileModule: ProfileModuleType,
         presenter: TabPresenterType,
         viewController: TabViewControllerType) {

        self.feedModule = feedModule
        self.cameraModule = cameraModule
        self.cameraTabModule = cameraTabModule
        self.profileModule = profileModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    override func start() {
        super.start()
        
        let feedCoordinator = self.feedModule.createCoordinator()
        let cameraTabCoordinator = self.cameraTabModule.createCoordinator(listener: self.presenter)
        let profileCoordinator = self.profileModule.createCoordinator(user: User(pfUser: PFUser.current()!))
        
        let feedController = UINavigationController(viewControllerType: feedCoordinator.viewController)
        let cameraTabController = cameraTabCoordinator.viewController.asViewController()
        let profileController = UINavigationController(viewControllerType: profileCoordinator.viewController)
        
        let viewControllers = [feedController, cameraTabController, profileController]
        
        feedController.tabBarItem = UITabBarItem.feed
        cameraTabController.tabBarItem = UITabBarItem.camera
        profileController.tabBarItem = UITabBarItem.profile
        
        let tabController = self.tabBarController
        tabController?.setViewControllers(viewControllers, animated: false)
        tabController?.tabBar.barStyle = .default
        tabController?.tabBar.isTranslucent = false
        tabController?.tabBar.tintColor = .black
        
        feedCoordinator.start()
        cameraTabCoordinator.start()
        profileCoordinator.start()
        self.attach(feedCoordinator)
        self.attach(cameraTabCoordinator)
        self.attach(profileCoordinator)
    }
    
    func attachCameraModule() {
        let coordinator = self.cameraModule.createCoordinator(listener: self.presenter)
        self.viewController.asViewController().present(coordinator.viewController) {
            coordinator.start()
        }
        self.cameraCoordinator = coordinator
        self.attach(coordinator)
    }
    
    func detachCameraModule() {
        self.tabBarController?.selectedIndex = 0
        self.detachModuleIfNeeded(self.cameraCoordinator, animated: true)
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
