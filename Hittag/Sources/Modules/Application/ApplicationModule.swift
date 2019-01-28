import ModuleArchitecture

final class ApplicationModule: Module, ApplicationModuleType {
    
    private let homeModule: TabModuleType
    private let loginModule: LoginModuleType
    private let authRepository: AuthRepositoryType
    
    init(homeModule: TabModuleType,
         loginModule: LoginModuleType,
         authRepository: AuthRepositoryType) {
        self.homeModule = homeModule
        self.loginModule = loginModule
        self.authRepository = authRepository
    }
    
    func createCoordinator(window: UIWindow) -> ApplicationCoordinatorType {
        let presenter = ApplicationPresenter(authRepository: self.authRepository)
        let coordinator = ApplicationCoordinator(window: window,
                                                 homeModule: self.homeModule,
                                                 loginModule: self.loginModule,
                                                 presenter: presenter)
        presenter.coordinator = coordinator
        return coordinator
    }
}
