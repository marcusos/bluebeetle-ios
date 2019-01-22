import ModuleArchitecture
import Vision

protocol CameraPresenterDelegate: AnyObject {

}

final class CameraPresenter: Presenter, CameraPresenterType {

    weak var coordinator: CameraCoordinatorType?
    weak var viewController: CameraPresenterView?
    weak var delegate: CameraPresenterDelegate?

    private let model = try? VNCoreMLModel(for: hittag().model)
    
    override func start() {
        //
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
            
            let configuration = CameraConfiguration(predictedClass: predclass, predictedConfidence: predconfidence)
            
            DispatchQueue.main.async {
                self.viewController?.render(configuration: configuration)
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
