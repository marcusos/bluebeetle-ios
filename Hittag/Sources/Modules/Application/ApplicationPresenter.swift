import ModuleArchitecture
import RxSwift

protocol ApplicationPresenterDelegate: AnyObject {
    
}

final class ApplicationPresenter: Presenter, ApplicationPresenterType {

    weak var delegate: ApplicationPresenterDelegate?
    weak var coordinator: ApplicationCoordinatorType?

    private let userRepository: UserRepositoryType
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }
    
    override func start() {
        self.userRepository.current()
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
    
}
