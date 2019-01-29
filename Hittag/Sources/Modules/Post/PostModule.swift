import ModuleArchitecture

final class PostModule: Module, PostModuleType {

    func createCoordinator(post: Post) -> PostCoordinatorType {

        let presenter = PostPresenter(post: post)
        let viewController = PostViewController()
        let coordinator = PostCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
