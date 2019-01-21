import ModuleArchitecture

final class CameraModule: Module, CameraModuleType {

    func createCoordinator(listener: CameraPresenterDelegate) -> CameraCoordinatorType {

        let presenter = CameraPresenter()
        let viewController = CameraViewController()
        let coordinator = CameraCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
