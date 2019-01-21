import ModuleArchitecture

protocol TabPresenterDelegate: AnyObject {

}

final class TabPresenter: Presenter, TabPresenterType {

    weak var coordinator: TabCoordinatorType?
    weak var viewController: TabPresenterView?
    weak var delegate: TabPresenterDelegate?

    override func start() {
        //
    }
}

extension TabPresenter: TabViewControllerDelegate {

}
