import UIKit
import ModuleArchitecture

protocol PostViewControllerDelegate: AnyObject {
    func didLikePost(post: Post)
    func titleButtonTapped(user: User)
}

final class PostViewController: UIViewController, PostViewControllerType {

    weak var delegate: PostViewControllerDelegate?
    private lazy var component: PostComponent<PostViewController> = {
        let component = PostComponent<PostViewController>()
        component.delegate = self
        return component
    }()

    override func loadView() {

        self.view = self.component
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }
}

extension PostViewController: PostPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: PostConfiguration) {

        self.component.render(configuration: configuration)
    }
}

extension PostViewController: PostComponentDelegate {
    func didLikePost(post: Post) {
        self.delegate?.didLikePost(post: post)
    }
    
    func titleButtonTapped(user: User) {
        self.delegate?.titleButtonTapped(user: user)
    }
}
