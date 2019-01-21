import UIKit

extension UIColor {
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

extension UIColor {
    public var redValue: CGFloat {
        return CIColor(color: self).red
    }
    
    public var greenValue: CGFloat {
        return CIColor(color: self).green
    }
    
    public var blueValue: CGFloat {
        return CIColor(color: self).blue
    }
    
    public var alphaValue: CGFloat {
        return CIColor(color: self).alpha
    }
    
    public var brightness: CGFloat {
        // https://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        return (self.redValue * 299 + self.greenValue * 587 + self.blueValue * 114) / 1000.0
    }
    
    public var isDark: Bool {
        return Float(self.brightness) < 0.7
    }
    
    public var isBright: Bool {
        return !self.isDark
    }
}

extension UIColor {
    public convenience init(rgb: String) {
        let trimmed = rgb.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "(", with: "")
        
        let values = trimmed.split(separator: ",")
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat
        
        if values.count >= 3 {
            r = CGFloat(Float(values[0]) ?? 0)
            g = CGFloat(Float(values[1]) ?? 0)
            b = CGFloat(Float(values[2]) ?? 0)
        } else {
            r = 0
            g = 0
            b = 0
        }
        
        if values.count == 4 {
            a = CGFloat(Float(values[3]) ?? 1)
        } else {
            a = 1
        }
        self.init(r: r, g: g, b: b, a: a)
    }
    
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespaces)
        let scanner = Scanner(string: hexString)
        let hasPrefix = hexString.hasPrefix("#")
        
        if (hasPrefix) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        let finalAlpha: CGFloat
        
        if (hasPrefix && hexString.count == 9) || (!hasPrefix && hexString.count == 8) {
            let a = Int(color >> 24) & mask
            finalAlpha = CGFloat(a) / 255.0
        } else if (hasPrefix && hexString.count == 7) || (!hasPrefix && hexString.count == 6) {
            finalAlpha = 1
        } else {
            finalAlpha = 0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: finalAlpha)
    }
}
