import UIKit
import ModuleArchitecture
import AVFoundation
import Vision

enum CameraDeviceInitializationError: Swift.Error {
    case unsupportedCaptureDevice(AVCaptureDevice?)
}

protocol CameraComponentDelegate: class {
    func closeButtonTapped()
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer)
}

final class CameraComponent: UIView, Component {
    weak var delegate: CameraComponentDelegate?
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var camera: CameraDevice? = {
        let captureSession = AVCaptureSession()
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                      mediaType: AVMediaType.video,
                                                      position: .back).devices.first
        let camera = try? CameraDevice(captureDevice: device)
        camera?.delegate = self
        return camera
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.camera?.set(frame: self.frame)
    }

    func start() {
        self.camera?.startRunning()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    @objc private func closeButtonTapped() {
        self.delegate?.closeButtonTapped()
    }
}

extension CameraComponent {

    func render(configuration: CameraConfiguration) {
        self.label.attributedText = configuration.text
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
        
        self.addSubview(self.label)
        self.addSubview(self.closeButton)
    }

    private func defineSubviewsConstraints() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.closeButton.topSafeAnchor.constraint(equalTo: self.topSafeAnchor, constant: Grid * 2),
            self.closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Grid * 2),
            self.closeButton.heightAnchor.constraint(equalToConstant: CGSize.closeButton.height),
            self.closeButton.widthAnchor.constraint(equalToConstant: CGSize.closeButton.width),
        ])
        
        NSLayoutConstraint.activate([
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension CameraComponent: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        if let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            self.delegate?.didOutputPixelBuffer(pixelBuffer: pixelBuffer)
        }
    }
}
