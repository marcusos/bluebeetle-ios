import ModuleArchitecture

final class ProfileModule: Module, ProfileModuleType {

    func createCoordinator() -> ProfileCoordinatorType {

        let presenter = ProfilePresenter()
        let viewController = ProfileViewController()
        let coordinator = ProfileCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
