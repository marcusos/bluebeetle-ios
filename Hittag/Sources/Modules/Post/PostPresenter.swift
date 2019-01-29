import ModuleArchitecture
import RxSwift

protocol PostPresenterDelegate: AnyObject {
    func attachProfileModule(user: User)
}

final class PostPresenter: Presenter, PostPresenterType {

    weak var coordinator: PostCoordinatorType?
    weak var viewController: PostPresenterView?
    weak var delegate: PostPresenterDelegate?

    private var post: Post
    private let postRepository: PostRepositoryType
    private let disposeBag = DisposeBag()
    
    init(post: Post, postRepository: PostRepositoryType) {
        self.post = post
        self.postRepository = postRepository
    }
    
    override func start() {
        self.viewController?.render(configuration: PostConfiguration(post: self.post))
    }
    
    func load(post: Post) {
        self.post = post
        self.viewController?.render(configuration: PostConfiguration(post: self.post))
    }
}

extension PostPresenter: PostViewControllerDelegate {
    func titleButtonTapped(user: User) {
        self.delegate?.attachProfileModule(user: user)
    }
    
    func didLikePost(post: Post) {
        self.postRepository.like(post: post)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] post in
                self?.load(post: post)
            })
            .disposed(by: self.disposeBag)
    }
}
