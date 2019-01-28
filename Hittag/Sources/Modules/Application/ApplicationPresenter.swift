import ModuleArchitecture
import RxSwift

protocol ApplicationPresenterDelegate: AnyObject {
    
}

final class ApplicationPresenter: Presenter, ApplicationPresenterType {

    weak var delegate: ApplicationPresenterDelegate?
    weak var coordinator: ApplicationCoordinatorType?

    private let authRepository: AuthRepositoryType
    private let disposeBag = DisposeBag()
    
    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }
    
    override func start() {
        self.authRepository.current()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handleUserEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handleUserEvent(_ event: MaybeEvent<User>) {
        switch event {
        case .completed, .error:
            self.coordinator?.attachLoginModule()
        case .success:
            self.coordinator?.attachHomeModule()
        }
    }
}

extension ApplicationPresenter: LoginPresenterDelegate {
    func didSignUpSuccessfuly(user: User) {
        self.coordinator?.attachHomeModule()
    }
}
