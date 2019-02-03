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
        cell.set(postModule: self.postModule,
                 post: post,
                 listener: self.listener,
                 parent: self.viewController)
        return cell
    }
}

final class PostModuleCell: UITableViewCell {
    private var coordinator: PostCoordinatorType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(postModule: PostModuleType, post: Post, listener: PostPresenterDelegate?, parent: UIViewController) {
        guard let listener = listener else { return }
        
        let coordinator = postModule.createCoordinator(cell: self, post: post, listener: listener)
        if coordinator === self.coordinator {
            self.coordinator?.load(post: post); return
        }
        
        let viewController = coordinator.viewController.asViewController()
        viewController.willMove(toParent: parent)
        self.addSubview(viewController.view)
        parent.addChild(viewController)
        viewController.view.makeEdgesEqualToSuperview()
        coordinator.start()
        self.coordinator = coordinator
    }
}
