import UIKit
import ModuleArchitecture

final class FeedComponent: UIView, Component {
    
    private var dataSource = TableViewDataSource<ContainerTableViewCell<PostComponent>>() {
        didSet {
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(ContainerTableViewCell<PostComponent>.self)
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
}

extension FeedComponent {

    func render(configuration: FeedConfiguration) {
        self.dataSource = .init(configurations: configuration.postConfigurations)
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
