import UIKit
import ModuleArchitecture
import TPKeyboardAvoiding

protocol LoginComponentDelegate: class {
    func facebookButtonTapped()
}

final class LoginComponent: UIView, Component {
    weak var delegate: LoginComponentDelegate?
    
    private let scrollView: UIScrollView = {
        let view = TPKeyboardAvoidingScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let wrapperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(padding: Grid * 2)
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
   
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Grid * 2.5
        return stackView
    }()
    
    private let facebookButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.color = UIColor(r: 59, g: 89, b: 152)
        button.highlightedColor = UIColor(r: 59, g: 89, b: 152).withAlphaComponent(0.6)
        button.disabledColor = UIColor(r: 223, g: 227, b: 238)
        button.setImage(UIImage(named: "icon_facebook"), for: .normal)
        button.setAttributedTitle("   Entrar com Facebook".title(.white, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init() {

        super.init(frame: .zero)
        self.customizeInterface()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    @objc private func facebookButtonTapped() {
        self.delegate?.facebookButtonTapped()
    }
}

extension LoginComponent {

    func render(configuration: LoginConfiguration) {
        self.facebookButton.isEnabled = configuration.loginButtonEnabled
    }
}

extension LoginComponent {

    private func customizeInterface() {

        self.backgroundColor = .white
        self.defineSubviews()
        self.defineSubviewsConstraints()
    }

    private func defineSubviews() {
        self.wrapperStackView.addArrangedSubview(self.inputStackView.wrapForVerticalAlignment())
        self.inputStackView.addArrangedSubview(self.imageView.wrapForPadding(UIEdgeInsets(leftRight: Grid * 10)))
        self.inputStackView.addArrangedSubview(self.facebookButton)
        self.scrollView.addSubview(self.wrapperStackView)
        self.addSubview(self.scrollView)
    }

    private func defineSubviewsConstraints() {
        self.scrollView.makeEdgesEqualToSuperview(usesSafeaArea: true)
        self.wrapperStackView.makeEdgesEqualToSuperview()
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            self.facebookButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            self.wrapperStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.wrapperStackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
        ])
        
        self.facebookButton.layer.cornerRadius = Grid * 0.5
    }
}
