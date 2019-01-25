import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol TabModuleType: ModuleType {

    func createCoordinator() -> TabCoordinatorType
}

protocol TabCoordinatorType: ViewableCoordinatorType {

    func attachCameraModule()
    func detachCameraModule()
}

protocol TabPresenterType: PresenterType, CameraPresenterDelegate, CameraTabPresenterDelegate {

    var delegate: TabPresenterDelegate? { get set }
}

protocol TabViewControllerType: TabBarControllerType {

    var listener: TabViewControllerDelegate? { get set }
}

protocol TabPresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: TabConfiguration)
}
