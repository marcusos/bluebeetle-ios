import UIKit

class BlockBasedTableViewDataSource<Model: Codable>: NSObject, UITableViewDataSource {
    var numberOfRowsInSection: (Int) -> Int
    
    var cellForRowAtIndexPath: (UITableView, IndexPath, Model) -> UITableViewCell = { _, _, _ in
        return UITableViewCell()
    }
    
    private let items: [Model]
    
    init(items: [Model]) {
        self.items = items
        self.numberOfRowsInSection = { _ in return items.count }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellForRowAtIndexPath(tableView, indexPath, self.items[indexPath.row])
    }
}
