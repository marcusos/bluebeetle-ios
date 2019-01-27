import UIKit
import ModuleArchitecture
import AVFoundation
import Vision

enum CameraDeviceInitializationError: Swift.Error {
    case unsupportedCaptureDevice(AVCaptureDevice?)
}

protocol CameraComponentDelegate: class {
    func closeButtonTapped()
    func helpButtonTapped()
    func didSelectChallengeConfiguration(_ configuration: ChallengeItemConfiguration)
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
    
    private let controlsStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = Grid * 2.5
        stackview.backgroundColor = .clear
        return stackview
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        return label
    }()
    
    private lazy var challengeSelectorComponent: ChallengeComponent = {
        let component = ChallengeComponent()
        component.delegate = self
        return component
    }()
    
    private let pictureButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "help"), for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pictureButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.color = .white
        button.highlightedColor = UIColor.lightGray.withAlphaComponent(0.8)
        button.disabledColor = UIColor.lightGray.withAlphaComponent(0.8)
        button.isEnabled = false
        return button
    }()
    
    private let selectedChallengeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = "...".subtitle(.white, weight: .bold)
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
    
    @objc private func helpButtonTapped() {
        self.delegate?.helpButtonTapped()
    }
}

extension CameraComponent {

    func render(configuration: CameraConfiguration) {
        self.challengeSelectorComponent.render(configuration: configuration.challengeConfiguration)
        self.showInfoLabelAndHideIfNeeded(text: configuration.infoLabelText)
        self.pictureButtonContainer.backgroundColor = configuration.pictureButtonContainerBackgroundColor
        self.pictureButton.isEnabled = configuration.pictureButtonEnabled
        self.selectedChallengeLabel.attributedText = configuration.selectedChallengeText
    }
    
    private func showInfoLabelAndHideIfNeeded(text: NSAttributedString?) {
        guard let text = text else {
            self.infoLabel.alpha = 0; return
        }
        
        self.infoLabel.alpha = 1
        self.infoLabel.attributedText = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.3, animations: {
                self.infoLabel.alpha = 0
            })
        }
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
        
        self.controlsStackView.addArrangedSubview(self.challengeSelectorComponent)
        self.controlsStackView.addArrangedSubview(self.pictureButtonContainer.wrapForHorizontalAlignment())
        self.controlsStackView.addArrangedSubview(self.selectedChallengeLabel.wrapForHorizontalAlignment())
        self.pictureButtonContainer.addSubview(self.pictureButton)
        self.addSubview(self.infoLabel)
        self.addSubview(self.controlsStackView)
        self.addSubview(self.closeButton)
        self.addSubview(self.helpButton)
    }

    private func defineSubviewsConstraints() {
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.pictureButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.helpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.closeButton.topSafeAnchor.constraint(equalTo: self.topSafeAnchor, constant: Grid * 2),
            self.closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Grid * 2),
            self.closeButton.heightAnchor.constraint(equalToConstant: CGSize.closeButton.height),
            self.closeButton.widthAnchor.constraint(equalToConstant: CGSize.closeButton.width),
        ])
        
        NSLayoutConstraint.activate([
            self.controlsStackView.bottomSafeAnchor.constraint(equalTo: self.bottomSafeAnchor, constant: -Grid * 2),
            self.controlsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.controlsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.pictureButtonContainer.heightAnchor.constraint(equalToConstant: 90),
            self.pictureButtonContainer.widthAnchor.constraint(equalToConstant: 90),
        ])
        
        NSLayoutConstraint.activate([
            self.pictureButton.centerYAnchor.constraint(equalTo: self.pictureButtonContainer.centerYAnchor),
            self.pictureButton.centerXAnchor.constraint(equalTo: self.pictureButtonContainer.centerXAnchor),
            self.pictureButton.heightAnchor.constraint(equalToConstant: 70),
            self.pictureButton.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        NSLayoutConstraint.activate([
            self.infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.helpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Grid * 2),
            self.helpButton.bottomSafeAnchor.constraint(equalTo: self.bottomSafeAnchor, constant: -Grid * 2),
            self.helpButton.heightAnchor.constraint(equalToConstant: 32),
            self.helpButton.widthAnchor.constraint(equalToConstant: 32),
        ])
        
        self.pictureButtonContainer.layer.cornerRadius = 45
        self.pictureButton.layer.cornerRadius = 35
        self.helpButton.layer.cornerRadius = 16
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

extension CameraComponent: ChallengeComponentDelegate {
    func didSelectConfiguration(_ configuration: ChallengeItemConfiguration) {
        self.delegate?.didSelectChallengeConfiguration(configuration)
    }
}
