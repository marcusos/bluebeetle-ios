import UIKit

final class PurchaseButton: BackgroundColorButton {
    private enum Constants {
        static let height: CGFloat = 80
    }
    
    override var color: UIColor {
        didSet {
            self.highlightedColor = self.color.withAlphaComponent(0.8)
        }
    }
    
    override var disabledColor: UIColor {
        set {}
        get { return self.highlightedColor.withAlphaComponent(0.3) }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.height)
    }
}
