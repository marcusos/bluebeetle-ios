import UIKit
import ModuleArchitecture
import AVFoundation

enum CameraDeviceInitializationError: Swift.Error {
    case unsupportedCaptureDevice(AVCaptureDevice?)
}

final class CameraComponent: UIView, Component {

    private let camera: CameraDevice? = {
        let captureSession = AVCaptureSession()
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                      mediaType: AVMediaType.video,
                                                      position: .back).devices.first
        return try? CameraDevice(captureDevice: device)
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.camera?.set(frame: self.frame)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
}

extension CameraComponent {

    func render(configuration: CameraConfiguration) {
        
    }
}

extension CameraComponent {

    private func customizeInterface() {

        self.defineSubviews()
        self.defineSubviewsConstraints()
    }

    private func defineSubviews() {
        if let camera = self.camera {
            self.layer.insertSublayer(camera.layer, at: 0)
        }
    }

    private func defineSubviewsConstraints() {
        
    }
}
