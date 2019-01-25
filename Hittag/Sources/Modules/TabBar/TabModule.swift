import ModuleArchitecture

final class TabModule: Module, TabModuleType {

    private let feedModule: FeedModuleType
    private let cameraModule: CameraModuleType
    private let cameraTabModule: CameraTabModuleType
    private let profileModule: ProfileModuleType
    
    init(feedModule: FeedModuleType,
         cameraModule: CameraModuleType,
         cameraTabModule: CameraTabModuleType,
         profileModule: ProfileModuleType) {
        
        self.feedModule = feedModule
        self.cameraModule = cameraModule
        self.cameraTabModule = cameraTabModule
        self.profileModule = profileModule
    }
    
    func createCoordinator() -> TabCoordinatorType {

        let presenter = TabPresenter()
        let viewController = TabViewController()
        let coordinator = TabCoordinator(feedModule: self.feedModule,
                                         cameraModule: self.cameraModule,
                                         cameraTabModule: self.cameraTabModule,
                                         profileModule: self.profileModule,
                                         presenter: presenter,
                                         viewController: viewController)
        viewController.listener = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
