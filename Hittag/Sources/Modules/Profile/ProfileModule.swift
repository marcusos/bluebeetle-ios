import ModuleArchitecture

final class ProfileModule: Module, ProfileModuleType {

    private let userRepository: UserRepositoryType
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }
    
    func createCoordinator(user: User) -> ProfileCoordinatorType {

        let presenter = ProfilePresenter(user: user, userRepository: self.userRepository)
        let viewController = ProfileViewController()
        let coordinator = ProfileCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
