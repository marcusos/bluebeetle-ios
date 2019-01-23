import ModuleArchitecture

protocol ProfilePresenterDelegate: AnyObject {

}

final class ProfilePresenter: Presenter, ProfilePresenterType {

    weak var coordinator: ProfileCoordinatorType?
    weak var viewController: ProfilePresenterView?
    weak var delegate: ProfilePresenterDelegate?

    override func start() {
        let eu = User(name: "Eu",
                      image: URL(string: "https://instagram.fcgh22-1.fna.fbcdn.net/vp/bef5dd0b8347f6f1167a78a005c46956/5CDDDE6D/t51.2885-19/s320x320/37746443_1801044999973001_3250850786313240576_n.jpg?_nc_ht=instagram.fcgh22-1.fna.fbcdn.net")!)
        
        let hittags = [
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
        
        self.viewController?.render(configuration: ProfileConfiguration(user: eu, hittags: hittags))
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {

}
