import ModuleArchitecture

final class CameraCoordinator: Coordinator<CameraPresenterType>, CameraCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: CameraPresenterType, viewController: CameraViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
}
