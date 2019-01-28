import ModuleArchitecture
import Vision
import RxSwift

protocol CameraPresenterDelegate: AnyObject {
    func cameraWantsToDismiss()
    func cameraWantsToPost(parameters: PostParameters)
}

final class CameraPresenter: Presenter, CameraPresenterType {

    weak var coordinator: CameraCoordinatorType?
    weak var viewController: CameraPresenterView?
    weak var delegate: CameraPresenterDelegate?
    
    private let challengeRepository: ChallengeRepositoryType
    private let disposeBag = DisposeBag()
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
    
    init(challengeRepository: ChallengeRepositoryType) {
        self.challengeRepository = challengeRepository
    }
    
    override func start() {
        self.challengeRepository.challenges()
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handleChallengesEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handleChallengesEvent(_ event: Event<[Challenge]>) {
        switch event {
        case .next(let challenges):
            self.configuration = self.configuration.with(challenges: challenges)
        case .error, .completed:
            print("error")
        }
    }
}

extension CameraPresenter: CameraViewControllerDelegate {
    func didOutputPixelBuffer(pixelBuffer: CVPixelBuffer) {
        self.pixelBuffer = pixelBuffer
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
