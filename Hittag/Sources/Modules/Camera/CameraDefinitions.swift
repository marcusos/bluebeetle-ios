import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol CameraModuleType: ModuleType {

    func createCoordinator(listener: CameraPresenterDelegate) -> CameraCoordinatorType
}

protocol CameraCoordinatorType: ViewableCoordinatorType {

}

protocol CameraPresenterType: PresenterType {

    var delegate: CameraPresenterDelegate? { get set }
}

protocol CameraViewControllerType: ViewControllerType {

    var delegate: CameraViewControllerDelegate? { get set }
}

protocol CameraPresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: CameraConfiguration)
}
