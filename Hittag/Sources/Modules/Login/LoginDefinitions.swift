import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol LoginModuleType: ModuleType {

    func createCoordinator(listener: LoginPresenterDelegate) -> LoginCoordinatorType
}

protocol LoginCoordinatorType: ViewableCoordinatorType {

}

protocol LoginPresenterType: PresenterType {

    var delegate: LoginPresenterDelegate? { get set }
}

protocol LoginViewControllerType: ViewControllerType {

    var delegate: LoginViewControllerDelegate? { get set }
}

protocol LoginPresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: LoginConfiguration)
}
