import ModuleArchitecture

final class ProfileModule: Module, ProfileModuleType {

    private let postModule: PostModuleType
    private let userRepository: UserRepositoryType
    
    init(postModule: PostModuleType, userRepository: UserRepositoryType) {
        self.postModule = postModule
        self.userRepository = userRepository
    }
    
    func createCoordinator(user: User) -> ProfileCoordinatorType {

        let presenter = ProfilePresenter(user: user, userRepository: self.userRepository)
        let viewController = ProfileViewController()
        let coordinator = ProfileCoordinator(postModule: self.postModule,
                                             presenter: presenter,
                                             viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
