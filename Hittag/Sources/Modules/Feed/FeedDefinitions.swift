import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol FeedModuleType: ModuleType {

    func createCoordinator() -> FeedCoordinatorType
}

protocol FeedCoordinatorType: ViewableCoordinatorType {

    func attachProfileModule(user: User)
}

protocol FeedPresenterType: PresenterType {

    var delegate: FeedPresenterDelegate? { get set }
}

protocol FeedViewControllerType: ViewControllerType {

    var delegate: FeedViewControllerDelegate? { get set }
}

protocol FeedPresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: FeedConfiguration)
}
