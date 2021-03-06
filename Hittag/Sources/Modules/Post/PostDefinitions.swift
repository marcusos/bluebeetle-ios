import ModuleArchitecture

// Builder object that configures the module and returns a coordinator.
// A module should always be instantiated via the createCoordinator method.
protocol PostModuleType: ModuleType {

    func createCoordinator(postId: PostId,
                           listener: PostPresenterDelegate) -> PostCoordinatorType
}

protocol PostCoordinatorType: ViewableCoordinatorType {

    func load(postId: PostId)
}

protocol PostPresenterType: PresenterType {

    var delegate: PostPresenterDelegate? { get set }
    func load(postId: PostId)
}

protocol PostViewControllerType: ViewControllerType {

    var delegate: PostViewControllerDelegate? { get set }
}

protocol PostPresenterView: AnyObject {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: PostConfiguration)
}
