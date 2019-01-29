import UIKit
import ModuleArchitecture

protocol FeedViewControllerDelegate: AnyObject {
    func didLikePost(post: Post)
    func titleButtonTapped(user: User)
    
    func onViewDidAppear()
}

final class FeedViewController: UIViewController, FeedViewControllerType {

    weak var delegate: FeedViewControllerDelegate?
    private lazy var component: FeedComponent = {
        let component = FeedComponent()
        component.delegate = self
        return component
    }()
    
    override func loadView() {

        self.view = self.component
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationItem.title = "Hittag"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.delegate?.onViewDidAppear()
    }
}

extension FeedViewController: FeedPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: FeedConfiguration) {

        self.component.render(configuration: configuration)
    }
}

extension FeedViewController: FeedComponentDelegate {
    func didLikePost(post: Post) {
        self.delegate?.didLikePost(post: post)
    }
    
    func titleButtonTapped(user: User) {
        self.delegate?.titleButtonTapped(user: user)
    }
}
