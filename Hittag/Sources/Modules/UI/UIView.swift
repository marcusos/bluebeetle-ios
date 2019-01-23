import UIKit

extension UIView {
    func makeEdgesEqualToSuperview(usesSafeaArea: Bool = false) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let superViewTopAnchor = usesSafeaArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let superViewBottomAnchor = usesSafeaArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.topAnchor.constraint(equalTo: superViewTopAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superViewBottomAnchor)
        ])
    }
}

extension UIView {
    var leftSafeAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var topSafeAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var rightSafeAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var bottomSafeAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
}
