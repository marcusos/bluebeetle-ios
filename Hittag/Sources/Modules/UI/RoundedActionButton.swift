import UIKit

final class RoundedActionButton: BackgroundColorButton {
    init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.color = .main
        self.highlightedColor = UIColor.main.withAlphaComponent(0.8)
        self.layer.cornerRadius = Grid * 3
        self.setTitleColor(.black, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Grid * 6)
    }
}
