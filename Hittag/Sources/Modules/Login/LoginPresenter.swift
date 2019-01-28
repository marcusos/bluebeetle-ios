import ModuleArchitecture
import RxSwift

protocol LoginPresenterDelegate: AnyObject {
    func didSignUpSuccessfuly(user: User)
}

final class LoginPresenter: Presenter, LoginPresenterType {

    weak var coordinator: LoginCoordinatorType?
    weak var viewController: LoginPresenterView?
    weak var delegate: LoginPresenterDelegate?
    
    private let authRepository: AuthRepositoryType
    private let disposeBag = DisposeBag()
    private var configuration = LoginConfiguration.empty {
        didSet {
            self.viewController?.render(configuration: self.configuration)
        }
    }
    
    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    override func start() {
        //
    }
}

extension LoginPresenter: LoginViewControllerDelegate {
    func facebookButtonTapped() {
        self.configuration = self.configuration.with(loginButtonEnabled: false)
        self.authRepository.signIn()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handleSignUpEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handleSignUpEvent(_ event: SingleEvent<User>) {
        switch event {
        case .success(let user):
            self.delegate?.didSignUpSuccessfuly(user: user)
        case .error(let error):
            print(error)
        }
        self.configuration = self.configuration.with(loginButtonEnabled: true)
    }
}
