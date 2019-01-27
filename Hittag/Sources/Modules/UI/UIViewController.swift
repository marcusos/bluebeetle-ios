import UIKit

extension UIViewController {
    func dismissPresentedControllerIfNeeded(animated: Bool = true, completion: @escaping () -> Void) {
        if let controller = self.presentedViewController {
            controller.dismiss(animated: animated, completion: completion)
        } else {
            completion()
        }
    }
    
    func addViewController(_ viewController: UIViewController, container: UIView? = nil) {
        let container = container ?? self.view
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        container?.addSubview(viewController.view)
        viewController.view.makeEdgesEqualToSuperview()
    }
}
