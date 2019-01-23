import ModuleArchitecture

final class LoginModule: Module, LoginModuleType {

    func createCoordinator(listener: LoginPresenterDelegate) -> LoginCoordinatorType {

        let presenter = LoginPresenter()
        let viewController = LoginViewController()
        let coordinator = LoginCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
