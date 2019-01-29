import ModuleArchitecture

protocol PostPresenterDelegate: AnyObject {

}

final class PostPresenter: Presenter, PostPresenterType {

    weak var coordinator: PostCoordinatorType?
    weak var viewController: PostPresenterView?
    weak var delegate: PostPresenterDelegate?

    private let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    override func start() {
        self.viewController?.render(configuration: PostConfiguration(post: self.post))
    }
}

extension PostPresenter: PostViewControllerDelegate {
    
}
