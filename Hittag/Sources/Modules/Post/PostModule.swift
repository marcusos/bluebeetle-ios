import ModuleArchitecture

final class PostModule: Module, PostModuleType {

    private var pool: [PostModuleCell: PostCoordinatorType] = [:]
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
    
    func createCoordinator(cell: PostModuleCell,
                           post: Post,
                           listener: PostPresenterDelegate?) -> PostCoordinatorType {
        
        if let coordinator = self.pool[cell] {
            return coordinator
        }
        
        let coordinator = self.createCoordinator(post: post, listener: listener)
        self.pool[cell] = coordinator
        return coordinator
    }
}
