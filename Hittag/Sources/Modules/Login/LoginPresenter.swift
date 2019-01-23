import ModuleArchitecture
import RxSwift

protocol LoginPresenterDelegate: AnyObject {
    func didSignUpSuccessfuly(user: User)
}

final class LoginPresenter: Presenter, LoginPresenterType {

    weak var coordinator: LoginCoordinatorType?
    weak var viewController: LoginPresenterView?
    weak var delegate: LoginPresenterDelegate?
    
    private let userRepository: UserRepositoryType
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    override func start() {
        //
    }
}

extension LoginPresenter: LoginViewControllerDelegate {
    func forgotPasswordButtonTapped(credentials: LoginCredentials) {
        
    }
    
    func signInButtonTapped(credentials: LoginCredentials) {
        
    }
    
    func signUpButtonTapped(credentials: LoginCredentials) {
        guard let userCredentials = UserCredentials(loginCredentials: credentials) else {
            return
        }
        
        self.userRepository.signUp(credentials: userCredentials)
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
    }
}

extension UserCredentials {
    init?(loginCredentials: LoginCredentials) {
        guard let email = loginCredentials.email, let password = loginCredentials.password else { return nil }
        self.init(email: email, password: password)
    }
}
