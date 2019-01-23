import ModuleArchitecture

final class LoginCoordinator: Coordinator<LoginPresenterType>, LoginCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: LoginPresenterType, viewController: LoginViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
}
