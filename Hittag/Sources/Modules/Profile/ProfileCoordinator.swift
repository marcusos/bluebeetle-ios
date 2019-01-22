import ModuleArchitecture

final class ProfileCoordinator: Coordinator<ProfilePresenterType>, ProfileCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: ProfilePresenterType, viewController: ProfileViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
}
