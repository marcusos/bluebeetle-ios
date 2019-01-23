import UIKit
import ModuleArchitecture
import TPKeyboardAvoiding

struct LoginCredentials {
    let email: String?
    let password: String?
}

protocol LoginComponentDelegate: class {
    func forgotPasswordButtonTapped(credentials: LoginCredentials)
    func signInButtonTapped(credentials: LoginCredentials)
    func signUpButtonTapped(credentials: LoginCredentials)
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
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .badge
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .badge
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let forgotPasswordButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.setAttributedTitle("Esqueceu a senha?".hint(.main), for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signInButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.color = .main
        button.highlightedColor = UIColor.main.withAlphaComponent(0.6)
        button.setAttributedTitle("Entrar".title(.white, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: BackgroundColorButton = {
        let button = BackgroundColorButton()
        button.setAttributedTitle("Criar conta".hint(.main), for: .normal)
        button.highlightedColor = UIColor.hint.withAlphaComponent(0.2)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init() {

        super.init(frame: .zero)
        self.customizeInterface()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    @objc private func forgotPasswordButtonTapped() {
        let credentials = LoginCredentials(email: self.usernameTextField.text, password: self.passwordTextField.text)
        self.delegate?.forgotPasswordButtonTapped(credentials: credentials)
    }
    
    @objc private func signInButtonTapped() {
        let credentials = LoginCredentials(email: self.usernameTextField.text, password: self.passwordTextField.text)
        self.delegate?.signInButtonTapped(credentials: credentials)
    }
    
    @objc private func signUpButtonTapped() {
        let credentials = LoginCredentials(email: self.usernameTextField.text, password: self.passwordTextField.text)
        self.delegate?.signUpButtonTapped(credentials: credentials)
    }
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
