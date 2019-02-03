import UIKit
import ModuleArchitecture
import Parse
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootCoordinator: CoordinatorType?
    private var container: ContainerType?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupParse(launchOptions: launchOptions)
        self.setupFacebook(application, launchOptions: launchOptions)
        
        let window = UIWindow()
        
        let dataContainerConfiguration = DataContainerConfiguration()
        let dataContainer = DataContainer(configuration: dataContainerConfiguration)
        let moduleConfiguration = ModuleContainerConfiguration(dataContainer: dataContainer)
        let moduleContainer = ModuleContainer(configuration: moduleConfiguration)
        let rootModule = moduleContainer.resolve() as ApplicationModuleType
        let rootCoordinator = rootModule.createCoordinator(window: window)
        rootCoordinator.start()
        
        self.window = window
        self.container = moduleContainer
        self.rootCoordinator = rootCoordinator
        return true
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let fbHandled = FBSDKApplicationDelegate.sharedInstance()?
            .application(app, open: url, options: options), fbHandled {
            return true
        }
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}

extension AppDelegate {
    private func setupParse(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Parse.initialize(with: ParseClientConfiguration {
            $0.applicationId = "eQZ2e8nVvCpTs43X1110yIpcFr6DDX6DyhKCl5vx"
            $0.clientKey = "5NZWSIpbStAdcziIeJQdZ7JQZ0LuCxcBDVBgbQQ8"
            $0.server = "https://parseapi.back4app.com/"
            $0.isLocalDatastoreEnabled = true
        })
    }
    
    private func setupFacebook(_ app: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance()?.application(app, didFinishLaunchingWithOptions: launchOptions)
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
    }
}
