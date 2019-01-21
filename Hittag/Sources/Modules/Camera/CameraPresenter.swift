import ModuleArchitecture

protocol CameraPresenterDelegate: AnyObject {

}

final class CameraPresenter: Presenter, CameraPresenterType {

    weak var coordinator: CameraCoordinatorType?
    weak var viewController: CameraPresenterView?
    weak var delegate: CameraPresenterDelegate?

    override func start() {
        //
    }
}

extension CameraPresenter: CameraViewControllerDelegate {

}
