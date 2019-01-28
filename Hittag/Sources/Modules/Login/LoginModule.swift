import ModuleArchitecture

final class LoginModule: Module, LoginModuleType {

    private let authRepository: AuthRepositoryType
    
    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }
    
    func createCoordinator(listener: LoginPresenterDelegate) -> LoginCoordinatorType {

        let presenter = LoginPresenter(authRepository: self.authRepository)
        let viewController = LoginViewController()
        let coordinator = LoginCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
