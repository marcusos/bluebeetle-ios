import UIKit
import ModuleArchitecture

protocol CellComponent: Component {
    
    associatedtype Delegate: AnyObject
    var delegate: Delegate? { get set }
}

final class ContainerTableViewCell<View: CellComponent>: UITableViewCell, CellComponent where View: UIView {
    
    let customView: View
    
    weak var delegate: View.Delegate? {
        didSet {
            self.customView.delegate = self.delegate
        }
    }
    
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
