import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol CameraTabModuleType: ModuleType {

    func createCoordinator(listener: CameraTabPresenterDelegate) -> CameraTabCoordinatorType
}

protocol CameraTabCoordinatorType: ViewableCoordinatorType {

}

protocol CameraTabPresenterType: PresenterType {

    var delegate: CameraTabPresenterDelegate? { get set }
}

protocol CameraTabViewControllerType: ViewControllerType {

    var delegate: CameraTabViewControllerDelegate? { get set }
}

protocol CameraTabPresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: CameraTabConfiguration)
}
