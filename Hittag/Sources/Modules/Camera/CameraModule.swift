import ModuleArchitecture

final class CameraModule: Module, CameraModuleType {

    private let challengeRepository: ChallengeRepositoryType
    
    init(challengeRepository: ChallengeRepositoryType) {
        self.challengeRepository = challengeRepository
    }
    
    func createCoordinator(listener: CameraPresenterDelegate) -> CameraCoordinatorType {

        let presenter = CameraPresenter(challengeRepository: self.challengeRepository)
        let viewController = CameraViewController()
        let coordinator = CameraCoordinator(presenter: presenter, viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.delegate = listener
        presenter.coordinator = coordinator
        return coordinator
    }
}
