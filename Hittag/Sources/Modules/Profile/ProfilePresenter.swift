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
    
    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

    override func start() {
        self.userRepository.current()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] user in
                self?.handleUser(user)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func handleUser(_ user: User) {
        self.viewController?.render(configuration: ProfileConfiguration(user: user, hittags: self.hittags))
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {

}

extension ProfilePresenter {
    var hittags: [Hittag] {
        return [
            Hittag.init(name: "fuscaazul",
                        image: URL(string: "https://instagram.fcgh22-1.fna.fbcdn.net/vp/5df3c6d819804e4ad64eb6a339e41dae/5CC1380C/t51.2885-15/sh0.08/e35/p640x640/49784279_596634510760891_5024978615261294605_n.jpg?_nc_ht=instagram.fcgh22-1.fna.fbcdn.net")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/camera.png")!),
            Hittag.init(name: "crepioca",
                        image: URL(string: "http://i-exc.ccm2.net/iex/1280/1352011521/1200662.jpg")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/dumbbell.png")!),
            Hittag.init(name: "husky",
                        image: URL(string: "https://s3.amazonaws.com/cdn-origin-etr.akc.org/wp-content/uploads/2017/11/12224256/Siberian-Husky-Care.jpg")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/dog.png")!),
            Hittag.init(name: "husky",
                        image: URL(string: "https://s3.amazonaws.com/cdn-origin-etr.akc.org/wp-content/uploads/2017/11/12224256/Siberian-Husky-Care.jpg")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/dog.png")!),
            Hittag.init(name: "fuscaazul",
                        image: URL(string: "https://instagram.fcgh22-1.fna.fbcdn.net/vp/5df3c6d819804e4ad64eb6a339e41dae/5CC1380C/t51.2885-15/sh0.08/e35/p640x640/49784279_596634510760891_5024978615261294605_n.jpg?_nc_ht=instagram.fcgh22-1.fna.fbcdn.net")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/camera.png")!),
            Hittag.init(name: "crepioca",
                        image: URL(string: "http://i-exc.ccm2.net/iex/1280/1352011521/1200662.jpg")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/dumbbell.png")!),
            Hittag.init(name: "husky",
                        image: URL(string: "https://meusanimais.com.br/wp-content/uploads/2017/06/border-collie.jpg")!,
                        icon: URL(string: "https://img.icons8.com/color/2x/dog.png")!),
        ]
    }
}
