import ModuleArchitecture

final class TabModule: Module, TabModuleType {

    private let feedModule: FeedModuleType
    private let cameraModule: CameraModuleType
    private let profileModule: ProfileModuleType
    
    init(feedModule: FeedModuleType, cameraModule: CameraModuleType, profileModule: ProfileModuleType) {
        self.feedModule = feedModule
        self.cameraModule = cameraModule
        self.profileModule = profileModule
    }
    
    func createCoordinator() -> TabCoordinatorType {

        let presenter = TabPresenter()
        let viewController = TabViewController()
        let coordinator = TabCoordinator(feedModule: self.feedModule,
                                         cameraModule: self.cameraModule,
                                         profileModule: self.profileModule,
                                         presenter: presenter,
                                         viewController: viewController)
        viewController.listener = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
