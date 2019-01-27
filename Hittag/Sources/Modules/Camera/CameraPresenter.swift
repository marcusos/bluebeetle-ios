import ModuleArchitecture
import Vision

protocol CameraPresenterDelegate: AnyObject {
    func cameraWantsToDismiss()
}

final class CameraPresenter: Presenter, CameraPresenterType {

    weak var coordinator: CameraCoordinatorType?
    weak var viewController: CameraPresenterView?
    weak var delegate: CameraPresenterDelegate?
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    private var configuration: CameraConfiguration = .empty {
        didSet {
            if oldValue != self.configuration {
                self.viewController?.render(configuration: self.configuration)
                if oldValue.challengeSelectorConfiguration.selectedConfiguration !=
                    self.configuration.challengeSelectorConfiguration.selectedConfiguration {
                    self.feedbackGenerator.selectionChanged()
                }
            }
        }
    }

    private let model = try? VNCoreMLModel(for: hittag().model)
    
    override func start() {
        
        self.viewController?.render(configuration: self.configuration)
    }
}

extension CameraPresenter: CameraViewControllerDelegate {
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer) {
        guard let model = self.model else { return }
        
        // run an inference with CoreML
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            // grab the inference results
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            
            // grab the highest confidence result
            guard let Observation = results.first else { return }
            
            // create the label text components
            let predclass = Observation.identifier
            let predconfidence = Observation.confidence
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func closeButtonTapped() {
        self.delegate?.cameraWantsToDismiss()
    }
    
    func didSelectChallengeConfiguration(_ configuration: ChallengeItemConfiguration) {
        self.configuration = self.configuration.with(selectedChallengeItemConfiguration: configuration)
    }
}
