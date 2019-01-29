import UIKit
import ModuleArchitecture

final class TableViewDataSource<Cell: CellComponent>: NSObject, UITableViewDataSource
where Cell: UITableViewCell {
    
    let configurations: [String: [Cell.Configuration]]
    weak var cellDelegate: Cell.Delegate?
    
    init(configurations: [Cell.Configuration] = [], cellDelegate: Cell.Delegate? = nil) {
        self.configurations = ["": configurations]
        self.cellDelegate = cellDelegate
    }
    
    init(configurations: [String: [Cell.Configuration]], cellDelegate: Cell.Delegate? = nil) {
        self.configurations = configurations
        self.cellDelegate = cellDelegate
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
        cell.delegate = self.cellDelegate
        let key = self.configurations.keys.map { $0 }[indexPath.section]
        guard let configuration = self.configurations[key]?[indexPath.row] else { fatalError() }
        cell.render(configuration: configuration)
        return cell
    }
}
