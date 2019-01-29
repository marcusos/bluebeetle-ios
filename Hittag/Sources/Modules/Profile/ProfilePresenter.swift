import ModuleArchitecture
import RxSwift

protocol ProfilePresenterDelegate: AnyObject {

}

final class ProfilePresenter: Presenter, ProfilePresenterType {

    weak var coordinator: ProfileCoordinatorType?
    weak var viewController: ProfilePresenterView?
    weak var delegate: ProfilePresenterDelegate?
    
    private let user: User
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepositoryType
    private var configuration: ProfileConfiguration? {
        didSet {
            if let configuration = self.configuration {
                self.viewController?.render(configuration: configuration)
            }
        }
    }
    
    init(user: User, userRepository: UserRepositoryType) {
        self.user = user
        self.userRepository = userRepository
    }

    override func start() {
        self.configuration = ProfileConfiguration(user: self.user, posts: [])
        self.loadData()
    }
    
    private func loadData() {
        self.userRepository.posts(user: self.user)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.handleDataEvent(event)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func handleDataEvent(_ event: Event<[Post]>) {
        switch event {
        case .next(let posts):
            self.configuration = ProfileConfiguration(user: self.user, posts: posts)
        case .completed, .error:
            break
        }
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {
    func onViewDidAppear() {
        self.coordinator?.detachPostModule()
    }
    
    func didSelectPost(post: Post) {
        self.coordinator?.attachPostModule(post: post)
    }
}
