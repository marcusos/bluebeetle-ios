import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol ApplicationModuleType: ModuleType {

    func createCoordinator(window: UIWindow) -> ApplicationCoordinatorType
}

protocol ApplicationCoordinatorType: CoordinatorType {
    
    func attachLoginModule()
    func attachHomeModule()
}

protocol ApplicationPresenterType: PresenterType, LoginPresenterDelegate {
    
    var delegate: ApplicationPresenterDelegate? { get set }
}
