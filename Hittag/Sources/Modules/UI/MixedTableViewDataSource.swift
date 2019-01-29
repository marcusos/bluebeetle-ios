import UIKit
import ModuleArchitecture

final class AnyComponent: Component {
    let view: UIView
    private let renderer: (Any) -> Void
    
    init<C: Component>(component: C) where C: UIView {
        self.view = component
        self.renderer = { value in component.render(configuration: value as! C.Configuration) }
    }

    func render(configuration: Any) {
        self.renderer(configuration)
    }
}

final class MixedTableViewDataSource: NSObject, UITableViewDataSource {
    private let components: [(AnyComponent, Any)]
    
    init(components: [(AnyComponent, Any)]) {
        self.components = components
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (component, configuration) = self.components[indexPath.row]
        component.render(configuration: configuration)
        return component.view as? UITableViewCell ?? UITableViewCell()
    }
}
