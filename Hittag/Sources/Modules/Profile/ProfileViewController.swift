import UIKit
import ModuleArchitecture

protocol ProfileViewControllerDelegate: AnyObject {
    func onViewDidAppear()
    func didSelectPost(post: Post)
}

final class ProfileViewController: UIViewController, ProfileViewControllerType {
    weak var delegate: ProfileViewControllerDelegate?
    
    private lazy var component: ProfileComponent = {
        let component = ProfileComponent()
        component.delegate = self
        return component
    }()

    override func loadView() {

        self.view = self.component
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.delegate?.onViewDidAppear()
    }
}

extension ProfileViewController: ProfilePresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: ProfileConfiguration) {

        self.navigationItem.title = configuration.title
        self.component.render(configuration: configuration)
    }
}

extension ProfileViewController: ProfileCompoentDelegate {
    func didSelectPost(post: Post) {
        self.delegate?.didSelectPost(post: post)
    }
}
