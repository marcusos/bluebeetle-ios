import UIKit
import ModuleArchitecture

protocol FeedComponentDelegate: AnyObject {
    func didLikePost(post: Post)
    func titleButtonTapped(user: User)
}

final class FeedComponent: UIView, Component {
    private unowned let viewController: UIViewController
    private weak var listener: PostPresenterDelegate?
    
    private var dataSource: UITableViewDataSource? {
        didSet {
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(FeedCell.self)
        return tableView
    }()
    
    init(listener: PostPresenterDelegate?, viewController: UIViewController) {
        self.viewController = viewController
        self.listener = listener
        super.init(frame: .zero)
        self.customizeInterface()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
}

extension FeedComponent {

    func render(configuration: FeedConfiguration) {
        self.dataSource = configuration.dataSource
    }
}

extension FeedComponent {

    private func customizeInterface() {

        self.backgroundColor = .white
        self.defineSubviews()
        self.defineSubviewsConstraints()
    }

    private func defineSubviews() {
        self.addSubview(self.tableView)
    }

    private func defineSubviewsConstraints() {
        self.tableView.makeEdgesEqualToSuperview()
    }
}
