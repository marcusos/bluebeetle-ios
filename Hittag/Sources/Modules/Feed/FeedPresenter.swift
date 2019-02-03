import ModuleArchitecture
import RxSwift

protocol FeedPresenterDelegate: AnyObject {

}

final class FeedPresenter: Presenter, FeedPresenterType {

    weak var coordinator: FeedCoordinatorType?
    weak var viewController: FeedPresenterView?
    weak var delegate: FeedPresenterDelegate?
    
    private let postModule: PostModuleType
    private let disposeBag = DisposeBag()
    private let feedRepository: FeedRepositoryType
    private var dataSource: PostModuleDataSource?
    
    private var configuration = FeedConfiguration() {
        didSet {
            self.viewController?.render(configuration: self.configuration)
        }
    }
    
    init(postModule: PostModuleType, feedRepository: FeedRepositoryType) {
        self.postModule = postModule
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
            if let viewController = self.viewController as? UIViewController {
                let dataSource = PostModuleDataSource(postModule: self.postModule,
                                                      posts: posts,
                                                      listener: self,
                                                      viewController: viewController)
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
