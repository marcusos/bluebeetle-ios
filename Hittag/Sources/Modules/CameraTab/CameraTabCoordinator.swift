import ModuleArchitecture

final class CameraTabCoordinator: Coordinator<CameraTabPresenterType>, CameraTabCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: CameraTabPresenterType, viewController: CameraTabViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
}
