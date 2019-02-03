import ModuleArchitecture

final class FeedCoordinator: Coordinator<FeedPresenterType>, FeedCoordinatorType {

    let viewController: ViewControllerType
    private let profileModule: ProfileModuleType
    private let postModule: PostModuleType
    
    private weak var profileCoordinator: ProfileCoordinatorType?

    init(profileModule: ProfileModuleType,
         postModule: PostModuleType,
         presenter: FeedPresenterType,
         viewController: FeedViewControllerType) {

        self.profileModule = profileModule
        self.postModule = postModule
        self.viewController = viewController
        super.init(presenter: presenter)
    }
    
    func dataSourceFor(posts: [Post]) -> UITableViewDataSource {
        let dataSource = BlockTableViewDataSource()
        
        dataSource.numberOfRowsInSection = { _ in
            return posts.count
        }
        
        dataSource.cellForRowAtIndexPath = { tableView, indexPath in
            let cell: PostModuleCell = tableView.dequeueReusableCell(for: indexPath)
            let post = posts[indexPath.row]
            
            if let coordinator = cell.coordinator {
                coordinator.load(post: post)
            } else {
                let coordinator = self.postModule.createCoordinator(cell: cell, post: post, listener: self.presenter)
                let parent = self.viewController.asViewController()
                let viewController = coordinator.viewController.asViewController()
                viewController.willMove(toParent: parent)
                cell.addSubview(viewController.view)
                parent.addChild(viewController)
                viewController.view.makeEdgesEqualToSuperview()
                coordinator.start()
                cell.coordinator = coordinator
            }
            return cell
        }
        return dataSource
    }
    
    func attachProfileModule(user: User) {
        let coordinator = self.profileModule.createCoordinator(user: user)
        let navigationController = self.viewController.asViewController().navigationController
        navigationController?.pushViewController(coordinator.viewController, animated: true)
        self.attach(coordinator)
        self.profileCoordinator = coordinator
        coordinator.start()
    }
    
    func detachProfileModule() {
        if let coordinator = self.profileCoordinator {
            self.detach(coordinator)
        }
    }
}

class BlockTableViewDataSource: NSObject, UITableViewDataSource {
    var numberOfRowsInSection: (Int) -> Int = { _ in return 1 }
    var cellForRowAtIndexPath: (UITableView, IndexPath) -> UITableViewCell = { _, _ in return UITableViewCell() }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellForRowAtIndexPath(tableView, indexPath)
    }
}
