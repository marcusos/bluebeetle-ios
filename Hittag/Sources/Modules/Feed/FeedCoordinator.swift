import ModuleArchitecture

final class FeedCoordinator: Coordinator<FeedPresenterType>, FeedCoordinatorType {

    let viewController: ViewControllerType
    private let profileModule: ProfileModuleType
    private let postModule: PostModuleType
    
    private weak var profileCoordinator: ProfileCoordinatorType?

    init(profileModule: ProfileModuleType,
         postModule: PostModuleType,
         presenter: FeedPresenterType,
         viewController: FeedViewControllerType) {

        self.profileModule = profileModule
        self.postModule = postModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    func dataSourceFor(posts: [Post]) -> UITableViewDataSource {
        return PostModuleDataSource(postModule: self.postModule,
                                    posts: posts,
                                    listener: self.presenter,
                                    viewController: self.viewController.asViewController())
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
