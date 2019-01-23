import ModuleArchitecture

final class ApplicationCoordinator: Coordinator<ApplicationPresenterType>, ApplicationCoordinatorType {

    private let homeModule: TabModuleType
    private let loginModule: LoginModuleType
    
    private weak var window: UIWindow?
    private weak var homeCoordinator: TabCoordinatorType?
    private weak var loginCoordinator: LoginCoordinatorType?
    
    init(window: UIWindow,
         homeModule: TabModuleType,
         loginModule: LoginModuleType,
         presenter: ApplicationPresenterType) {
        
        self.window = window
        self.homeModule = homeModule
        self.loginModule = loginModule
        super.init(presenter: presenter)
    }
}

extension ApplicationCoordinator: ApplicationPresenterDelegate {
    func attachHomeModule() {
        let coordinator = self.homeModule.createCoordinator()
        self.window?.rootViewController = coordinator.viewController.asViewController()
        self.window?.makeKeyAndVisible()
        self.homeCoordinator = coordinator
        coordinator.start()
        self.attach(coordinator)
    }
    
    func attachLoginModule() {
        let coordinator = self.loginModule.createCoordinator(listener: self.presenter)
        self.window?.rootViewController = coordinator.viewController.asViewController()
        self.window?.makeKeyAndVisible()
        self.loginCoordinator = coordinator
        coordinator.start()
        self.attach(coordinator)
    }
}

extension ViewableCoordinatorType {
    private func detachModuleIfNeeded(_ coordinator: ViewableCoordinatorType?,
                                      animated: Bool,
                                      completion: @escaping () -> Void) {
        
        if let coordinator = coordinator {
            coordinator.viewController.asViewController().dismissPresentedControllerIfNeeded(animated: animated) {
                coordinator.viewController.asViewController().dismiss(animated: animated) {
                    completion()
                    self.detach(coordinator)
                }
            }
        } else {
            completion()
        }
    }
}
