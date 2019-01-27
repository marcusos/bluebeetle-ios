import UIKit
import ModuleArchitecture
import Parse
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootCoordinator: CoordinatorType?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupParse(launchOptions: launchOptions)
        self.setupFacebook(application, launchOptions: launchOptions)
        
        let window = UIWindow()
        let homeModule = TabModule(feedModule: FeedModule(),
                                   cameraModule: CameraModule(),
                                   cameraTabModule: CameraTabModule(),
                                   profileModule: ProfileModule(userRepository: UserRepository()),
                                   postRepository: PostRepository())
        let rootModule = ApplicationModule(homeModule: homeModule,
                                           loginModule: LoginModule(userRepository: UserRepository()),
                                           userRepository: UserRepository())
        let rootCoordinator = rootModule.createCoordinator(window: window)
        rootCoordinator.start()
        self.window = window
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
        })
    }
    
    private func setupFacebook(_ app: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance()?.application(app, didFinishLaunchingWithOptions: launchOptions)
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
    }
}
