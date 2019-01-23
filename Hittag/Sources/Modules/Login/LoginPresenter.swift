import ModuleArchitecture

protocol LoginPresenterDelegate: AnyObject {

}

final class LoginPresenter: Presenter, LoginPresenterType {

    weak var coordinator: LoginCoordinatorType?
    weak var viewController: LoginPresenterView?
    weak var delegate: LoginPresenterDelegate?

    override func start() {
        //
    }
}

extension LoginPresenter: LoginViewControllerDelegate {

}
