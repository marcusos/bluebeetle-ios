import ModuleArchitecture
import RxSwift

protocol PostPresenterDelegate: AnyObject {
    func attachProfileModule(user: User)
}

final class PostPresenter: Presenter, PostPresenterType {
    weak var coordinator: PostCoordinatorType?
    weak var viewController: PostPresenterView?
    weak var delegate: PostPresenterDelegate?

    private var postId: PostId
    private let postRepository: PostRepositoryType
    private var postLikeDisposable: Disposable?
    private var postListenerDisposable: Disposable?
    
    init(postId: String, postRepository: PostRepositoryType) {
        self.postId = postId
        self.postRepository = postRepository
    }
    
    override func start() {
        self.listenTo(postId: self.postId)
    }
    
    func load(postId: PostId) {
        self.postId = postId
        self.listenTo(postId: self.postId)
    }
    
    private func listenTo(postId: PostId) {
        self.postListenerDisposable?.dispose()
        self.postListenerDisposable = self.postRepository
            .listenTo(postId: postId)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] post in
                guard let weakSelf = self else { return }
                weakSelf.postId = post.id
                weakSelf.viewController?.render(configuration: PostConfiguration(post: post))
            })
    }
    
    deinit {
        self.postListenerDisposable?.dispose()
    }
}

extension PostPresenter: PostViewControllerDelegate {
    func titleButtonTapped(user: User) {
        self.delegate?.attachProfileModule(user: user)
    }
    
    func didLikePost(post: Post) {
        self.postLikeDisposable?.dispose()
        self.postLikeDisposable = self.postRepository
            .like(postId: post.id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] post in
                guard let weakSelf = self else { return }
                weakSelf.postId = post.id
                weakSelf.viewController?.render(configuration: PostConfiguration(post: post))
            })
    }
}
