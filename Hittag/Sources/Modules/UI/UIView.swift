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
    func addShadow(configuration: (CALayer) -> Void = { _ in }) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.5
        configuration(self.layer)
        self.layer.masksToBounds =  false
    }
    
    func makeCircle() {
        var minDimension = min(self.bounds.width, self.bounds.height)
        if minDimension.truncatingRemainder(dividingBy: 2) != 0 {
            minDimension += 1
        }
        self.layer.cornerRadius = minDimension * 0.5
        self.layer.masksToBounds = true
    }
}
