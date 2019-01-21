import UIKit

extension String {
    func header(_ color: UIColor = .header, weight: UIFont.Weight = .bold) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.header(weight: weight),
            .foregroundColor: color
        ])
    }
    
    func title(_ color: UIColor = .title, weight: UIFont.Weight = .bold) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.title(weight: weight),
            .foregroundColor: color
        ])
    }
    
    func subtitle(_ color: UIColor = .subtitle, weight: UIFont.Weight = .medium) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.subtitle(weight: weight),
            .foregroundColor: color
        ])
    }
    
    func hittag(_ color: UIColor = .hittag, weight: UIFont.Weight = .bold) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.hittag(weight: weight),
            .foregroundColor: color
        ])
    }
    
    func quantityTitle(_ color: UIColor = .quantityTitle, weight: UIFont.Weight = .medium) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.quantityTitle(weight: weight),
            .foregroundColor: color
        ])
    }
    
    func quantity(_ color: UIColor = .quantity, weight: UIFont.Weight = .medium) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.quantity(weight: weight),
            .foregroundColor: color
        ])
    }
}

extension UIFont {
    static func header(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 32, weight: weight)
    }
    
    static func title(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 18, weight: weight)
    }
    
    static func subtitle(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 14, weight: weight)
    }
    
    static func hittag(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 11, weight: weight)
    }
    
    static func quantityTitle(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 15, weight: weight)
    }
    
    static func quantity(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 12, weight: weight)
    }
}

extension UIColor {
    static var header: UIColor {
        return .black
    }
    
    static var title: UIColor {
        return .black
    }
    
    static var subtitle: UIColor {
        return .darkGray
    }
    
    static var hittag: UIColor {
        return .black
    }
    
    static var quantityTitle: UIColor {
        return .darkGray
    }
    
    static var quantity: UIColor {
        return UIColor(r: 84, g: 161, b: 0)
    }
}

extension NSAttributedString {
    var strikedthrough: NSAttributedString {
        return self.adding(attributes: [.strikethroughStyle : 1])
    }
    
    var unerlyned: NSAttributedString {
        return self.adding(attributes: [.underlineStyle : 1])
    }
    
    func adding(attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return mutable
    }
}
