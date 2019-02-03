import UIKit
import ModuleArchitecture

final class PostModuleDataSource: NSObject, UITableViewDataSource {
    let postModule: PostModuleType
    let posts: [Post]
    private let viewController: UIViewController
    private weak var listener: PostPresenterDelegate?
    
    init(postModule: PostModuleType, posts: [Post], listener: PostPresenterDelegate?, viewController: UIViewController) {
        self.postModule = postModule
        self.posts = posts
        self.listener = listener
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostModuleCell = tableView.dequeueReusableCell(for: indexPath)
        let post = self.posts[indexPath.row]
        
        if let coordinator = cell.coordinator {
            coordinator.load(post: post)
        } else {
            let coordinator = self.postModule.createCoordinator(cell: cell, post: post, listener: self.listener)
            let parent = self.viewController
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
}

final class PostModuleCell: UITableViewCell {
    var coordinator: PostCoordinatorType?
}
