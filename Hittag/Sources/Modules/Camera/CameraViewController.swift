import UIKit
import ModuleArchitecture
import Vision

protocol CameraViewControllerDelegate: AnyObject {
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer)
}

final class CameraViewController: UIViewController, CameraViewControllerType {

    weak var delegate: CameraViewControllerDelegate?
    
    private lazy var component: CameraComponent = {
        let component = CameraComponent()
        component.delegate = self
        return component
    }()

    override func loadView() {

        self.view = self.component
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.title = "Camera"
        self.navigationItem.title = "Camera"
        self.component.start()
    }
}

extension CameraViewController: CameraPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: CameraConfiguration) {

        self.component.render(configuration: configuration)
    }
}

extension CameraViewController: CameraComponentDelegate {
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer) {
        self.delegate?.didOutputPixelBuffer(pixelBuffer: pixelBuffer)
    }
}
