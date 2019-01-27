import ModuleArchitecture
import Kingfisher

protocol ChallengeItemDelegate: class {
    
}

struct ChallengeItemConfiguration: Hashable {
    let challenge: Challenge
    let index: Int
    
    private(set) var isSelected: Bool
    
    var image: URL {
        return self.challenge.image
    }
    
    var borderColor: CGColor {
        return self.isSelected ? UIColor.main.cgColor : UIColor.clear.cgColor
    }
    
    var imageColor: UIColor {
        return self.isSelected ? .main : .white
    }
    
    var backgroundColor: UIColor {
        return self.isSelected ? .white : UIColor.black.withAlphaComponent(0.7)
    }
    
    init(challenge: Challenge, index: Int) {
        self.challenge = challenge
        self.index = index
        self.isSelected = false
    }
    
    func with(isSelected: Bool) -> ChallengeItemConfiguration {
        var this = self
        this.isSelected = isSelected
        return this
    }
}

final class ChallengeItemComponent: UIView, Component {
    weak var delegate: ChallengeItemDelegate?
    
    private let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: ChallengeItemConfiguration) {
        self.imageButton.kf.setImage(with: configuration.image, for: .normal)
        self.imageButton.tintColor = configuration.imageColor
        self.backgroundColor = configuration.backgroundColor
        self.layer.borderColor = configuration.borderColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height * 0.5
    }
}

extension ChallengeItemComponent {
    private func customizeInterface() {
        self.layer.borderWidth = 1
        self.defineSubviews()
        self.defineSubviewsConstraints()
    }
    
    private func defineSubviews() {
        self.addSubview(self.imageButton.wrapForPadding(UIEdgeInsets(padding: Grid * 1.2)))
    }
    
    private func defineSubviewsConstraints() {
        self.imageButton.superview?.makeEdgesEqualToSuperview()
    }
}
