import ModuleArchitecture

final class LoginModule: Module, LoginModuleType {

    private let userRepository: UserRepositoryType
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }
    
    func createCoordinator(listener: LoginPresenterDelegate) -> LoginCoordinatorType {

        let presenter = LoginPresenter(userRepository: self.userRepository)
        let viewController = LoginViewController()
        let coordinator = LoginCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
