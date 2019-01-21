import UIKit
import ModuleArchitecture

protocol TabViewControllerDelegate: AnyObject {

}

final class TabViewController: UITabBarController, TabViewControllerType {

    weak var listener: TabViewControllerDelegate?

    override func viewDidLoad() {

        super.viewDidLoad()
    }
}

extension TabViewController: TabPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: TabConfiguration) {

    }
}
