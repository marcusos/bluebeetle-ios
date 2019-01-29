import UIKit
import ModuleArchitecture

protocol FeedViewControllerDelegate: PostPresenterDelegate {
    func onViewDidAppear()
}

final class FeedViewController: UIViewController, FeedViewControllerType {

    weak var delegate: FeedViewControllerDelegate?
    
    private lazy var component: FeedComponent = {
        let component = FeedComponent(listener: self.delegate, viewController: self)
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
