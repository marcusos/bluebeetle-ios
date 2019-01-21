import UIKit

class BackgroundColorButton: UIButton {
    public enum Defaults {
        public static var color = UIColor.clear
        public static var highlightedColor =  UIColor.clear
        public static var disabledColor = UIColor.gray
    }
    
    private var originalTitle: String? = ""
    
    private var fadedTintColor: UIColor {
        return self.tintColor.withAlphaComponent(0.2)
    }
    
    public var color: UIColor = Defaults.color {
        didSet {
            self.updateBackgroundImages()
        }
    }
    
    public var highlightedColor: UIColor = Defaults.highlightedColor {
        didSet {
            self.updateBackgroundImages()
        }
    }
    
    public var disabledColor: UIColor = Defaults.disabledColor {
        didSet {
            self.updateBackgroundImages()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.updateBackgroundImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.configure()
        self.updateBackgroundImages()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.layer.borderColor = self.tintColor.cgColor
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.layer.borderColor = self.fadedTintColor.cgColor
            } else {
                self.layer.borderColor = self.tintColor.cgColor
            }
        }
    }
    
    open func configure() {
        self.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.adjustsImageWhenDisabled = false
        self.adjustsImageWhenHighlighted = false
    }
    
    private func updateBackgroundImages() {
        let normalImage = UIImage(color: self.color)
        let highlightedImage = UIImage(color: self.highlightedColor)
        let disabledImage = UIImage(color: self.disabledColor)
        
        self.setBackgroundImage(normalImage, for: .normal)
        self.setBackgroundImage(highlightedImage, for: .highlighted)
        self.setBackgroundImage(disabledImage, for: .disabled)
    }
}
