import ModuleArchitecture

final class ApplicationModule: Module, ApplicationModuleType {
    
    private let homeModule: TabModuleType
    private let loginModule: LoginModuleType
    private let userRepository: UserRepositoryType
    
    init(homeModule: TabModuleType,
         loginModule: LoginModuleType,
         userRepository: UserRepositoryType) {
        self.homeModule = homeModule
        self.loginModule = loginModule
        self.userRepository = userRepository
    }
    
    func createCoordinator(window: UIWindow) -> ApplicationCoordinatorType {
        let presenter = ApplicationPresenter(userRepository: self.userRepository)
        let coordinator = ApplicationCoordinator(window: window,
                                                 homeModule: self.homeModule,
                                                 loginModule: self.loginModule,
                                                 presenter: presenter)
        presenter.coordinator = coordinator
        return coordinator
    }
}
