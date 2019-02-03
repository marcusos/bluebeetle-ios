import ModuleArchitecture

final class FeedModule: Module, FeedModuleType {

    private let profileModule: ProfileModuleType
    private let postModule: PostModuleType
    private let feedRepository: FeedRepositoryType
    
    init(profileModule: ProfileModuleType,
         postModule: PostModuleType,
         feedRepository: FeedRepositoryType) {
        self.profileModule = profileModule
        self.postModule = postModule
        self.feedRepository = feedRepository
    }
    
    func createCoordinator() -> FeedCoordinatorType {

        let presenter = FeedPresenter(postModule: self.postModule, feedRepository: self.feedRepository)
        let viewController = FeedViewController()
        let coordinator = FeedCoordinator(profileModule: self.profileModule,
                                          presenter: presenter,
                                          viewController: viewController)
        viewController.delegate = presenter
        presenter.viewController = viewController
        presenter.coordinator = coordinator
        return coordinator
    }
}
