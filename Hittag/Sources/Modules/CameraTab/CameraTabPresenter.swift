import ModuleArchitecture

protocol CameraTabPresenterDelegate: AnyObject {
    func onCameraTabTapped()
}

final class CameraTabPresenter: Presenter, CameraTabPresenterType {

    weak var coordinator: CameraTabCoordinatorType?
    weak var viewController: CameraTabPresenterView?
    weak var delegate: CameraTabPresenterDelegate?
}

extension CameraTabPresenter: CameraTabViewControllerDelegate {
    func onViewWillAppear() {
        self.delegate?.onCameraTabTapped()
    }
}
