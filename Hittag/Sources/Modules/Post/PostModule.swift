import ModuleArchitecture

final class PostModule: Module, PostModuleType {

    private let postRepository: PostRepositoryType
    
    init(postRepository: PostRepositoryType) {
        self.postRepository = postRepository
    }
    
    func createCoordinator(post: Post,
                           listener: PostPresenterDelegate?) -> PostCoordinatorType {
        
        let presenter = PostPresenter(post: post, postRepository: self.postRepository)
        let viewController = PostViewController()
        let coordinator = PostCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
