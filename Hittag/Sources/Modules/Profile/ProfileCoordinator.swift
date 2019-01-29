import ModuleArchitecture

final class ProfileCoordinator: Coordinator<ProfilePresenterType>, ProfileCoordinatorType {

    let viewController: ViewControllerType
    private let postModule: PostModuleType
    
    private weak var postCoordinator: PostCoordinatorType?

    init(postModule: PostModuleType, presenter: ProfilePresenterType, viewController: ProfileViewControllerType) {

        self.postModule = postModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    func attachPostModule(post: Post) {
        let coordinator = self.postModule.createCoordinator(post: post)
        let navigationController = self.viewController.asViewController().navigationController
        navigationController?.pushViewController(coordinator.viewController, animated: true)
        self.attach(coordinator)
        self.postCoordinator = coordinator
        coordinator.start()
    }
    
    func detachPostModule() {
        if let coordinator = self.postCoordinator {
            self.detach(coordinator)
        }
    }
}
