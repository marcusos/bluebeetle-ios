import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol ProfileModuleType: ModuleType {

    func createCoordinator(user: User) -> ProfileCoordinatorType
}

protocol ProfileCoordinatorType: ViewableCoordinatorType {

}

protocol ProfilePresenterType: PresenterType {

    var delegate: ProfilePresenterDelegate? { get set }
}

protocol ProfileViewControllerType: ViewControllerType {

    var delegate: ProfileViewControllerDelegate? { get set }
}

protocol ProfilePresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: ProfileConfiguration)
}
