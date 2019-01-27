import UIKit
import Kingfisher

struct CameraHelpConfiguration: Equatable {
    let imageUrl: URL?
    let title: String
    let text: String
    let buttonText: NSAttributedString
    let textAlignment: NSTextAlignment
    
    static var challengeHelp: CameraHelpConfiguration {
        let url = URL(string: "https://res.cloudinary.com/twenty20/private_images/t_watermark-criss-cross-10/v1473325077000/photosp/2ed51456-d6a0-4f9d-bc18-c718931dacbc/stock-photo-nature-park-dog-spring-girl-selfie-husky-flowers-outside-2ed51456-d6a0-4f9d-bc18-c718931dacbc.jpg")
        let text = """
                        1. Abra a camera e selecione um desafio
                        2. Cada desafio é composto por uma cena, ela pode ser um objeto, uma paisagem ou até mesmo uma selfie com um husky
                        3. Tire uma foto que reproduza a cena do desafio
                        4. Se sua foto for aceita, você ganha sua reputação! :D
                    """
        return CameraHelpConfiguration(imageUrl: url,
                                       title: "Como funciona?",
                                       text: text,
                                       buttonText: "Entendi".title(.white),
                                       textAlignment: .left)
    }
}

protocol CameraHelpComponentDelegate: class {
    
    func didTapActionButton()
}

final class CameraHelpComponent: UIView {
    
    weak var delegate: CameraHelpComponentDelegate?
    
    private let mainContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Grid * 2
        return stackView
    }()
    
    private let contentContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: Grid * 4, bottom: Grid * 4, right: Grid * 4)
        stackView.spacing = Grid * 3
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let actionButton: RoundedActionButton = {
        let button = RoundedActionButton()
        button.color = .black
        button.highlightedColor = UIColor.black.withAlphaComponent(0.8)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: CameraHelpConfiguration) {
        self.imageView.kf.setImage(with: configuration.imageUrl, options: [.cacheMemoryOnly])
        self.titleLabel.text = configuration.title
        self.textLabel.text = configuration.text
        self.textLabel.textAlignment = configuration.textAlignment
        self.actionButton.setAttributedTitle(configuration.buttonText, for: .normal)
    }
    
    private func customizeInterface() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.addSubviews()
        self.addConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(self.mainContainerStackView)
        
        self.mainContainerStackView.addArrangedSubview(self.imageView)
        self.mainContainerStackView.addArrangedSubview(self.contentContainerStackView)
        
        self.contentContainerStackView.addArrangedSubview(self.titleLabel)
        self.contentContainerStackView.addArrangedSubview(self.textLabel)
        self.contentContainerStackView.addArrangedSubview(self.actionButton)
    }
    
    private func addConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.actionButton.translatesAutoresizingMaskIntoConstraints = false
        self.mainContainerStackView.makeEdgesEqualToSuperview()
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 300),
            self.imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func actionButtonTapped() {
        self.delegate?.didTapActionButton()
    }
}

protocol CameraHelpControllerDelegate: class {
    func cameraHelpController(cameraHelpController: CameraHelpController, didTapActionButtonWith configuration: CameraHelpConfiguration)
    func cameraHelpControllerWantsToClose(cameraHelpController: CameraHelpController)
}

final class CameraHelpController: UIViewController {
    
    weak var delegate: CameraHelpControllerDelegate?
    private(set) var configuration: CameraHelpConfiguration
    
    private lazy var component: CameraHelpComponent = {
        let component = CameraHelpComponent()
        component.delegate = self
        return component
    }()
    
    override func loadView() {
        self.view = self.component
    }
    
    init(configuration: CameraHelpConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.component.render(configuration: self.configuration)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
}

extension CameraHelpController: CameraHelpComponentDelegate {
    func didTapActionButton() {
        self.delegate?.cameraHelpController(cameraHelpController: self, didTapActionButtonWith: self.configuration)
    }
}

extension CameraHelpController: PopupClosableController {
    func didTapCloseButton() {
        self.delegate?.cameraHelpControllerWantsToClose(cameraHelpController: self)
    }
}
