import UIKit
import ModuleArchitecture

protocol LoginViewControllerDelegate: AnyObject {
    func facebookButtonTapped()
}

final class LoginViewController: UIViewController, LoginViewControllerType {
    weak var delegate: LoginViewControllerDelegate?
    
    private lazy var component: LoginComponent = {
        let component = LoginComponent()
        component.delegate = self
        return component
    }()

    override func loadView() {

        self.view = self.component
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }
}

extension LoginViewController: LoginPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: LoginConfiguration) {

        self.component.render(configuration: configuration)
    }
}

extension LoginViewController: LoginComponentDelegate {
    func facebookButtonTapped() {
        self.delegate?.facebookButtonTapped()
    }
}
