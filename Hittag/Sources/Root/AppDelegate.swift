import UIKit
import ModuleArchitecture
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootCoordinator: CoordinatorType?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupParse()
        
        let window = UIWindow()
        
        let homeModule = TabModule(feedModule: FeedModule(),
                                   cameraModule: CameraModule(),
                                   profileModule: ProfileModule())
        
        let rootModule = ApplicationModule(homeModule: homeModule,
                                           loginModule: LoginModule(),
                                           userRepository: UserRepository())
        
        let rootCoordinator = rootModule.createCoordinator(window: window)
        rootCoordinator.start()
        self.window = window
        self.rootCoordinator = rootCoordinator
        return true
    }
    
    private func setupParse() {
        Parse.initialize(with: ParseClientConfiguration {
            $0.applicationId = "eQZ2e8nVvCpTs43X1110yIpcFr6DDX6DyhKCl5vx"
            $0.clientKey = "5NZWSIpbStAdcziIeJQdZ7JQZ0LuCxcBDVBgbQQ8"
            $0.server = "https://parseapi.back4app.com/"
        })
    }
}
