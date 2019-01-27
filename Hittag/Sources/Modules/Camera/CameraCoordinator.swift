import ModuleArchitecture

final class CameraCoordinator: Coordinator<CameraPresenterType>, CameraCoordinatorType {

    let viewController: ViewControllerType

    init(presenter: CameraPresenterType, viewController: CameraViewControllerType) {

        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    func showChallengeHelp() {
        let cameraHelpController = CameraHelpController(configuration: .challengeHelp)
        let popupViewController = PopupViewController(contentViewController: cameraHelpController)
        cameraHelpController.delegate = self
        self.viewController.asViewController().present(popupViewController, animated: true)
    }
}

extension CameraCoordinator: CameraHelpControllerDelegate {
    func cameraHelpController(cameraHelpController: CameraHelpController,
                              didTapActionButtonWith configuration: CameraHelpConfiguration) {
        self.viewController.asViewController().dismiss(animated: true)
    }
    
    func cameraHelpControllerWantsToClose(cameraHelpController: CameraHelpController) {
        self.viewController.asViewController().dismiss(animated: true)
    }
}
