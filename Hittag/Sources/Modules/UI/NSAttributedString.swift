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
    
    func hint(_ color: UIColor = .hint, weight: UIFont.Weight = .bold) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.hint(weight: weight),
            .foregroundColor: color
        ])
    }
    
    func hashtag(_ color: UIColor = .hashtag, weight: UIFont.Weight = .bold) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.hashtag(weight: weight),
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
    
    static func hint(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 12, weight: weight)
    }
    
    static func hashtag(weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: 11, weight: weight)
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
    
    static var hint: UIColor {
        return .darkGray
    }
    
    static var hashtag: UIColor {
        return .black
    }
}

extension NSAttributedString {
    var strikedthrough: NSAttributedString {
        return self.adding(attributes: [.strikethroughStyle : 1])
    }
    
    var unerlyned: NSAttributedString {
        return self.adding(attributes: [.underlineStyle : 1])
    }
    
    func with(color: UIColor) -> NSAttributedString {
        return self.adding(attributes: [.foregroundColor : color])
    }
    
    func outlined(color: UIColor, width: CGFloat) -> NSAttributedString {
        return self.adding(attributes: [.strokeColor : color, .strokeWidth: -width])
    }
    
    func adding(attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return mutable
    }
}
