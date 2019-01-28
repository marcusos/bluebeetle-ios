import UIKit
import ModuleArchitecture

final class ContainerTableViewCell<View: Component>: UITableViewCell, Component
where View: UIView {
    
    let customView: View
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.customView = View()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.customView)
        self.customView.makeEdgesEqualToSuperview()
    }
    
    init(view: View) {
        self.customView = view
        super.init(style: .default, reuseIdentifier: nil)
        self.contentView.addSubview(self.customView)
        self.customView.makeEdgesEqualToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: View.Configuration) {
        self.customView.render(configuration: configuration)
    }
}
