import ModuleArchitecture

final class CameraTabModule: Module, CameraTabModuleType {

    func createCoordinator(listener: CameraTabPresenterDelegate) -> CameraTabCoordinatorType {

        let presenter = CameraTabPresenter()
        let viewController = CameraTabViewController()
        let coordinator = CameraTabCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
