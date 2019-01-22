import ModuleArchitecture

final class TabModule: Module, TabModuleType {

    private let feedModule: FeedModuleType
    private let cameraModule: CameraModuleType
    
    init(feedModule: FeedModuleType, cameraModule: CameraModuleType) {
        self.feedModule = feedModule
        self.cameraModule = cameraModule
    }
    
    func createCoordinator() -> TabCoordinatorType {

        let presenter = TabPresenter()
        let viewController = TabViewController()
        let coordinator = TabCoordinator(feedModule: self.feedModule,
                                         cameraModule: self.cameraModule,
                                         presenter: presenter,
                                         viewController: viewController)
        viewController.listener = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
