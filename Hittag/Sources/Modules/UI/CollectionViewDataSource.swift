import UIKit
import ModuleArchitecture

final class CollectionViewDataSource<Cell: Component>: NSObject, UICollectionViewDataSource where Cell: UICollectionViewCell {
    let configurations: [String: [Cell.Configuration]]
    
    init(configurations: [Cell.Configuration] = []) {
        self.configurations = ["": configurations]
    }
    
    init(configurations: [String: [Cell.Configuration]]) {
        self.configurations = configurations
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = self.configurations.keys.map { $0 }[section]
        return self.configurations[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let key = self.configurations.keys.map { $0 }[indexPath.section]
        guard let configuration = self.configurations[key]?[indexPath.row] else { fatalError() }
        cell.render(configuration: configuration)
        return cell
    }
}
