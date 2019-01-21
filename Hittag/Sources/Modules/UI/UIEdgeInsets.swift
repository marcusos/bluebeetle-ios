import UIKit

extension UIEdgeInsets {
    init(padding: CGFloat) {
        self.init(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }
    
    init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }
    
    init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: right)
    }
    
    init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }
    
    init(leftRight: CGFloat) {
        self.init(top: 0, left: leftRight, bottom: 0, right: leftRight)
    }
    
    init(topBottom: CGFloat) {
        self.init(top: topBottom, left: 0, bottom: topBottom, right: 0)
    }
    
    init(topBottom: CGFloat, leftRight: CGFloat) {
        self.init(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }
}

extension UIEdgeInsets {
    func left(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: value, bottom: self.bottom, right: self.right)
    }
    
    func top(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: self.left, bottom: self.bottom, right: self.right)
    }
    
    func right(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: value)
    }
    
    func bottom(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: value, right: self.right)
    }
}

extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -self.top, left: -self.left, bottom: -self.bottom, right: -self.right)
    }
}
