import UIKit
import MZFormSheetPresentationController

final class PopupViewController: MZFormSheetPresentationViewController {
    
    override init(contentViewController viewController: UIViewController) {
        let alertContainer = AlertContainerController(contentViewController: viewController)
        
        super.init(contentViewController: alertContainer)

        self.presentationController?.contentViewSize = UIView.layoutFittingExpandedSize
        self.presentationController?.shouldCenterVertically = true
        self.presentationController?.movementActionWhenKeyboardAppears = .alwaysAboveKeyboard
        self.presentationController?.backgroundVisibilityPercentage = 0.9
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

protocol PopupClosableController: class {
    func didTapCloseButton()
}

private final class AlertContainerController: UIViewController {
    private let contentViewController: UIViewController
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Grid * 2
        return stackView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setImage(UIImage(named: "bt_close_ios"), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    private func customizeInterface() {
        self.view.backgroundColor = .clear
        self.addSubviews()
        self.addConstraints()
    }
    
    private func addSubviews() {
        self.view.addSubview(self.containerStackView)
        
        self.containerStackView.addArrangedSubview(self.closeButton.wrapForHorizontalAlignment(.trailing))
        self.containerStackView.addArrangedSubview(self.container)
        self.addViewController(self.contentViewController, container: self.container)
    }
    
    private func addConstraints() {
        self.closeButton.widthAnchor.constraint(equalToConstant: 44)
        self.closeButton.heightAnchor.constraint(equalToConstant: 44)
        self.containerStackView.makeEdgesEqualToSuperview()
        self.contentViewController.view.layer.cornerRadius = Grid * 2
    }
    
    @objc private func didTapCloseButton() {
        if let closable = self.contentViewController as? PopupClosableController {
            closable.didTapCloseButton()
        } else {
            self.dismiss(animated: true)
        }
    }
}
