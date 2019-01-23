import UIKit
import ModuleArchitecture
import TPKeyboardAvoiding

final class LoginComponent: UIView, Component {

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
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .badge
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .badge
        return textField
    }()
    
    private let forgotPasswordButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.setAttributedTitle("Esqueceu a senha?".hint(.main), for: .normal)
        button.highlightedColor = UIColor.hint.withAlphaComponent(0.2)
        return button
    }()
    
    private let signInButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.color = .main
        button.highlightedColor = UIColor.main.withAlphaComponent(0.6)
        button.setAttributedTitle("Entrar".title(.white, weight: .regular), for: .normal)
        return button
    }()
    
    private let signUpButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.setAttributedTitle("Criar conta".hint(.main), for: .normal)
        button.highlightedColor = UIColor.hint.withAlphaComponent(0.2)
        return button
    }()
    
    init() {

        super.init(frame: .zero)
        self.customizeInterface()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
}

extension LoginComponent {

    func render(configuration: LoginConfiguration) {
        
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
        self.inputStackView.addArrangedSubview(self.usernameTextField)
        self.inputStackView.addArrangedSubview(self.passwordTextField)
        self.inputStackView.addArrangedSubview(self.forgotPasswordButton.wrapForHorizontalAlignment(.trailing))
        self.inputStackView.addArrangedSubview(self.signInButton)
        self.inputStackView.addArrangedSubview(self.signUpButton)
        self.scrollView.addSubview(self.wrapperStackView)
        self.addSubview(self.scrollView)
    }

    private func defineSubviewsConstraints() {
        self.scrollView.makeEdgesEqualToSuperview(usesSafeaArea: true)
        self.wrapperStackView.makeEdgesEqualToSuperview()
        
        NSLayoutConstraint.activate([
            self.usernameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            self.signInButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            self.wrapperStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.wrapperStackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
        ])
        
        self.signInButton.layer.cornerRadius = Grid * 0.5
    }
}
