import UIKit

final class SeparatorLineView: UIView {
    var axis: NSLayoutConstraint.Axis {
        didSet {
            if oldValue != self.axis {
                self.layoutIfNeeded()
            }
        }
    }
    
    init(axis: NSLayoutConstraint.Axis = .horizontal) {
        self.axis = axis
        super.init(frame: .zero)
        self.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override var intrinsicContentSize: CGSize {
        switch axis {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: 1)
        case .vertical:
            return CGSize(width: 1, height: UIView.noIntrinsicMetric)
        }
    }
    
    static func vertical() -> SeparatorLineView {
        let view = SeparatorLineView()
        view.axis = .vertical
        return view
    }
    
    static func horizontal() -> SeparatorLineView {
        return SeparatorLineView()
    }
}
