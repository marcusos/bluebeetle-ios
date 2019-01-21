import ModuleArchitecture
import UIKit

public struct BadgeConfiguration {
    let text: NSAttributedString
    let padding: UIEdgeInsets
    let backgroundColor: UIColor
    let cornerRadius: CGFloat?
    
    init(text: NSAttributedString,
         padding: UIEdgeInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3),
         backgroundColor: UIColor,
         cornerRadius: CGFloat? = nil) {
        self.text = text
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

public final class Badge: UILabel, Component {
    
    public var padding: UIEdgeInsets = .zero {
        didSet {
            self.updateLayer()
        }
    }
    
    public var cornerRadius: CGFloat? {
        didSet {
            self.updateLayer()
        }
    }
    
    public var borderColor: UIColor? {
        get { return self.layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    public var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    public init() {
        super.init(frame: .zero)
        self.updateLayer()
        self.textAlignment = .center
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textAlignment = .center
        self.clipsToBounds = true
    }
    
    fileprivate func updateLayer() {
        self.layoutIfNeeded()
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        if size.width == 0 && size.height == 0 {
            return .zero
        }
        
        let width = size.width + self.padding.left + self.padding.right
        let height = size.height + self.padding.top + self.padding.bottom
        let minWidthOrWidth = max(width, height)
        return CGSize(width: minWidthOrWidth, height: height)
    }
    
    public override func textRect(forBounds bounds: CGRect,
                                  limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds,
                                  limitedToNumberOfLines: numberOfLines)
        
        if rect.width == 0 && rect.height == 0 {
            return .zero
        }
        else {
            return rect.inset(by: self.padding.inverted())
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let frame = self.frame
        let minDimension = min(frame.height, frame.width)
        self.layer.cornerRadius =  minDimension * 0.5
    }
    
    public func render(configuration: BadgeConfiguration) {
        self.attributedText = configuration.text
        self.padding = configuration.padding
        self.cornerRadius = configuration.cornerRadius
        self.backgroundColor = configuration.backgroundColor
    }
}
