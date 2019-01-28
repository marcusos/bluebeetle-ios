import ModuleArchitecture
import RxSwift

protocol ProfilePresenterDelegate: AnyObject {

}

final class ProfilePresenter: Presenter, ProfilePresenterType {

    weak var coordinator: ProfileCoordinatorType?
    weak var viewController: ProfilePresenterView?
    weak var delegate: ProfilePresenterDelegate?
    
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepositoryType
    private var configuration: ProfileConfiguration? {
        didSet {
            if let configuration = self.configuration {
                self.viewController?.render(configuration: configuration)
            }
        }
    }
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    override func start() {
        self.loadData()
    }
    
    private func loadData() {
        self.userRepository.posts()
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handleDataEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handleDataEvent(_ event: Event<(User, [Post])>) {
        switch event {
        case .next(let (user, posts)):
            self.configuration = ProfileConfiguration(user: user, posts: posts)
        case .completed, .error:
            break
        }
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {

}
