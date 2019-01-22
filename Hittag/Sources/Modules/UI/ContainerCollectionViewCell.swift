import UIKit
import ModuleArchitecture

final class ContainerCollectionViewCell<View: Component>: UICollectionViewCell, Component where View: UIView {
    let customView: View
    
    override init(frame: CGRect) {
        self.customView = View()
        super.init(frame: .zero)
        self.contentView.addSubview(self.customView)
        self.customView.makeEdgesEqualToSuperview()
    }

    init(view: View) {
        self.customView = view
        super.init(frame: .zero)
        self.contentView.addSubview(self.customView)
        self.customView.makeEdgesEqualToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: View.Configuration) {
        self.customView.render(configuration: configuration)
    }
}
