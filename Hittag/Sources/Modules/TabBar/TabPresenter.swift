import ModuleArchitecture
import RxSwift

protocol TabPresenterDelegate: AnyObject {

}

final class TabPresenter: Presenter, TabPresenterType {

    weak var coordinator: TabCoordinatorType?
    weak var viewController: TabPresenterView?
    weak var delegate: TabPresenterDelegate?
    
    private let feedRepository: FeedRepositoryType
    private let disposeBag = DisposeBag()
    
    init(feedRepository: FeedRepositoryType) {
        self.feedRepository = feedRepository
    }

    override func start() {
        //
    }
}

extension TabPresenter: TabViewControllerDelegate {

}

extension TabPresenter: CameraPresenterDelegate {
    func cameraWantsToDismiss() {
        self.coordinator?.detachCameraModule()
    }
    
    func cameraWantsToPost(parameters: PostParameters) {
        self.coordinator?.detachCameraModule()
        self.feedRepository.post(parameters: parameters)
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handlePostEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handlePostEvent(_ event: CompletableEvent) {
        //
    }
}

extension TabPresenter: CameraTabPresenterDelegate {
    func onCameraTabTapped() {
        self.coordinator?.attachCameraModule()
    }
}
