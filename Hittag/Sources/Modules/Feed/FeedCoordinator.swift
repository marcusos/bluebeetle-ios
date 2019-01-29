import ModuleArchitecture

final class FeedCoordinator: Coordinator<FeedPresenterType>, FeedCoordinatorType {

    let viewController: ViewControllerType
    let profileModule: ProfileModuleType
    
    private weak var profileCoordinator: ProfileCoordinatorType?

    init(profileModule: ProfileModuleType, presenter: FeedPresenterType, viewController: FeedViewControllerType) {

        self.profileModule = profileModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    func attachProfileModule(user: User) {
        let coordinator = self.profileModule.createCoordinator(user: user)
        let navigationController = self.viewController.asViewController().navigationController
        navigationController?.pushViewController(coordinator.viewController, animated: true)
        self.attach(coordinator)
        self.profileCoordinator = coordinator
        coordinator.start()
    }
    
    func detachProfileModule() {
        if let coordinator = self.profileCoordinator {
            self.detach(coordinator)
        }
    }
}
