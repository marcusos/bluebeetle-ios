import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootCoordinator: TabCoordinatorType?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        let rootModule = TabModule(feedModule: FeedModule())
        let rootCoordinator = rootModule.createCoordinator()
        let navigationController = UINavigationController(viewControllerType: rootCoordinator.viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        rootCoordinator.start()
        
        self.window = window
        self.rootCoordinator = rootCoordinator
        return true
    }
}
