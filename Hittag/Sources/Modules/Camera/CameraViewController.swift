import UIKit
import ModuleArchitecture

protocol CameraViewControllerDelegate: AnyObject {

}

final class CameraViewController: UIViewController, CameraViewControllerType {

    weak var delegate: CameraViewControllerDelegate?
    private lazy var component = CameraComponent()

    override func loadView() {

        self.view = self.component
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }
}

extension CameraViewController: CameraPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: CameraConfiguration) {

        self.component.render(configuration: configuration)
    }
}
