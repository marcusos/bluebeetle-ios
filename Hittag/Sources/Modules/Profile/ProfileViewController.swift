import UIKit
import ModuleArchitecture

protocol ProfileViewControllerDelegate: AnyObject {

}

final class ProfileViewController: UIViewController, ProfileViewControllerType {

    weak var delegate: ProfileViewControllerDelegate?
    private lazy var component = ProfileComponent()

    override func loadView() {

        self.view = self.component
    }
}

extension ProfileViewController: ProfilePresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: ProfileConfiguration) {

        self.navigationItem.title = configuration.title
        self.component.render(configuration: configuration)
    }
}
