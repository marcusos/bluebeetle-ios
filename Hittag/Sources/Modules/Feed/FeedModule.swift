import ModuleArchitecture

final class FeedModule: Module, FeedModuleType {

    func createCoordinator() -> FeedCoordinatorType {

        let presenter = FeedPresenter()
        let viewController = FeedViewController()
        let coordinator = FeedCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
