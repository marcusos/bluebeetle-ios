import ModuleArchitecture
import Vision

protocol CameraPresenterDelegate: AnyObject {
    func cameraWantsToDismiss()
    func cameraWantsToPost(parameters: PostParameters)
}

final class CameraPresenter: Presenter, CameraPresenterType {

    weak var coordinator: CameraCoordinatorType?
    weak var viewController: CameraPresenterView?
    weak var delegate: CameraPresenterDelegate?
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let model = try? VNCoreMLModel(for: hittag().model)
    private var pixelBuffer: CVPixelBuffer?
    
    private var configuration: CameraConfiguration = .empty {
        didSet {
            if oldValue != self.configuration {
                self.viewController?.render(configuration: self.configuration)
                if oldValue.challengeConfiguration.selectedConfiguration !=
                    self.configuration.challengeConfiguration.selectedConfiguration {
                        self.feedbackGenerator.selectionChanged()
                }
            }
        }
    }
    
    override func start() {
        
        self.viewController?.render(configuration: self.configuration)
    }
}

extension CameraPresenter: CameraViewControllerDelegate {
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer) {
        self.pixelBuffer = pixelBuffer
//        guard let model = self.model else { return }
//
//        // run an inference with CoreML
//        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
//            
//            // grab the inference results
//            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
//            
//            // grab the highest confidence result
//            guard let Observation = results.first else { return }
//            
//            // create the label text components
//            let predclass = Observation.identifier
//            let predconfidence = Observation.confidence
//        }
        
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func closeButtonTapped() {
        self.delegate?.cameraWantsToDismiss()
    }
    
    func didSelectChallengeConfiguration(_ configuration: ChallengeItemConfiguration) {
        self.configuration = self.configuration.with(selectedItem: configuration)
    }
    
    func helpButtonTapped() {
        self.coordinator?.showChallengeHelp()
    }
    
    func pictureButtonTapped() {
        guard let pixelBuffer = self.pixelBuffer else { return }
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        guard let tempImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let image = UIImage(cgImage: tempImage, scale: UIScreen.main.scale, orientation: .leftMirrored)
        guard let imageData = image.pngData() else { return }
        guard let challenge = self.configuration.challengeConfiguration.selectedConfiguration?.challenge else { return }
        let parameters = PostParameters(image: imageData, challenge: challenge)
        self.delegate?.cameraWantsToPost(parameters: parameters)
    }
}
