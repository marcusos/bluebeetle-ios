import ModuleArchitecture

protocol FeedPresenterDelegate: AnyObject {

}

final class FeedPresenter: Presenter, FeedPresenterType {

    weak var coordinator: FeedCoordinatorType?
    weak var viewController: FeedPresenterView?
    weak var delegate: FeedPresenterDelegate?

    override func start() {
        let eu = User.init(name: "Eu", image: URL(string: "https://instagram.fcgh22-1.fna.fbcdn.net/vp/bef5dd0b8347f6f1167a78a005c46956/5CDDDE6D/t51.2885-19/s320x320/37746443_1801044999973001_3250850786313240576_n.jpg?_nc_ht=instagram.fcgh22-1.fna.fbcdn.net")!)
        
        let azeitao = User.init(name: "Téo", image: URL(string: "https://scontent.fcgh22-1.fna.fbcdn.net/v/t1.0-9/1234969_557061524342713_357135411_n.jpg?_nc_cat=105&_nc_ht=scontent.fcgh22-1.fna&oh=a136f843a576923137098db2785ef0b8&oe=5CBD129E")!)
        
        let posts = [
            Post.init(text: "Encontrei o Sacana!",
                      image: URL(string: "https://instagram.fcgh22-1.fna.fbcdn.net/vp/5df3c6d819804e4ad64eb6a339e41dae/5CC1380C/t51.2885-15/sh0.08/e35/p640x640/49784279_596634510760891_5024978615261294605_n.jpg?_nc_ht=instagram.fcgh22-1.fna.fbcdn.net")!,
                      hittags: [Hittag(name: "#fuscao"), Hittag(name: "#fuscaazul"), Hittag(name: "#vacation"), Hittag(name: "#acheiosafado")],
                      user: eu),
            Post.init(text: "Encontrei o Sacana!",
                      image: URL(string: "https://imganuncios.mitula.net/volkswagen_fusca_1970_fusca_4830008519744234296.jpg")!,
                      hittags: [Hittag(name: "#fuscao")],
                      user: azeitao),
            
        ]
        
        self.viewController?.render(configuration: FeedConfiguration(postConfigurations:
            posts.map(PostConfiguration.init)))
    }
}

extension FeedPresenter: FeedViewControllerDelegate {

}
