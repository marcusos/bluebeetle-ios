import ModuleArchitecture

final class FeedCoordinator: Coordinator<FeedPresenterType>, FeedCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: FeedPresenterType, viewController: FeedViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
}
