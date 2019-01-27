import UIKit
import ModuleArchitecture
import Vision

protocol CameraViewControllerDelegate: AnyObject {
    func closeButtonTapped()
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer)
    func didSelectChallengeConfiguration(_ configuration: ChallengeItemConfiguration)
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
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    func closeButtonTapped() {
        self.delegate?.closeButtonTapped()
    }
    
    func didSelectChallengeConfiguration(_ configuration: ChallengeItemConfiguration) {
        self.delegate?.didSelectChallengeConfiguration(configuration)
    }
}
