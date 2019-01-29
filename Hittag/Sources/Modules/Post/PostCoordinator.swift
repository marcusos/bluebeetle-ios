import ModuleArchitecture

final class PostCoordinator: Coordinator<PostPresenterType>, PostCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: PostPresenterType, viewController: PostViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
}