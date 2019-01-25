import UIKit
import ModuleArchitecture

protocol CameraTabViewControllerDelegate: AnyObject {
    func onViewWillAppear()
}

final class CameraTabViewController: UIViewController, CameraTabViewControllerType {

    weak var delegate: CameraTabViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.onViewWillAppear()
    }
}

extension CameraTabViewController: CameraTabPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: CameraTabConfiguration) {

    }
}
