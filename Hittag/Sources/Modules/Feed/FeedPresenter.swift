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
    private var dataSource: PostModuleDataSource?
    
    private var configuration = FeedConfiguration() {
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
            if let dataSource = self.coordinator?.dataSourceFor(posts: posts) {
                self.configuration = self.configuration.with(dataSource: dataSource)
            }
        case .completed, .error:
            break
        }
    }
}

extension FeedPresenter: PostPresenterDelegate {
    func attachProfileModule(user: User) {
        self.coordinator?.attachProfileModule(user: user)
    }
}

extension FeedPresenter: FeedViewControllerDelegate {
    func onViewDidAppear() {
        self.coordinator?.detachProfileModule()
    }
}
