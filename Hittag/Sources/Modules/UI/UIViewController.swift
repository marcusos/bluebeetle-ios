import UIKit

extension UIViewController {
    func dismissPresentedControllerIfNeeded(animated: Bool = true, completion: @escaping () -> Void) {
        if let controller = self.presentedViewController {
            controller.dismiss(animated: animated, completion: completion)
        } else {
            completion()
        }
    }
}
