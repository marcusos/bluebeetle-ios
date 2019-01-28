import ModuleArchitecture
import RxSwift

protocol FeedPresenterDelegate: AnyObject {

}

final class FeedPresenter: Presenter, FeedPresenterType {

    weak var coordinator: FeedCoordinatorType?
    weak var viewController: FeedPresenterView?
    weak var delegate: FeedPresenterDelegate?
    
    private let disposeBag = DisposeBag()
    private let feedRepository: FeedRepositoryType
    
    private var configuration = FeedConfiguration(postConfigurations: []) {
        didSet {
            self.viewController?.render(configuration: self.configuration)
        }
    }
    
    init(feedRepository: FeedRepositoryType) {
        self.feedRepository = feedRepository
    }

    override func start() {
        self.feedRepository.feed()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handleFeedEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handleFeedEvent(_ event: Event<[Post]>) {
        switch event {
        case .next(let posts):
            self.configuration = self.configuration.with(postConfigurations: posts.map(PostConfiguration.init))
        case .completed, .error:
            break
        }
    }
}

extension FeedPresenter: FeedViewControllerDelegate {

}
