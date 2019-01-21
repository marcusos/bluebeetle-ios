import UIKit
import ModuleArchitecture

protocol FeedViewControllerDelegate: AnyObject {

}

final class FeedViewController: UIViewController, FeedViewControllerType {

    weak var delegate: FeedViewControllerDelegate?
    private lazy var component = FeedComponent()
    
    override func loadView() {

        self.view = self.component
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.title = "Hittag"
    }
}

extension FeedViewController: FeedPresenterView {

    // This is the communication point from presenter to view controller.
    // You can change the name for something more contextual if needed.
    func render(configuration: FeedConfiguration) {

        self.component.render(configuration: configuration)
    }
}
