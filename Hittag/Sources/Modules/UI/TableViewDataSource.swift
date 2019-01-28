import UIKit
import ModuleArchitecture

final class TableViewDataSource<Cell: Component>: NSObject, UITableViewDataSource
where Cell: UITableViewCell {
    
    let configurations: [String: [Cell.Configuration]]
    
    init(configurations: [Cell.Configuration] = []) {
        self.configurations = ["": configurations]
    }
    
    init(configurations: [String: [Cell.Configuration]]) {
        self.configurations = configurations
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.configurations.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.configurations.keys.map { $0 }[section]
        return self.configurations[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        let key = self.configurations.keys.map { $0 }[indexPath.section]
        guard let configuration = self.configurations[key]?[indexPath.row] else { fatalError() }
        cell.render(configuration: configuration)
        return cell
    }
}
