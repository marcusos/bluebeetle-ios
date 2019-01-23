import UIKit
import ModuleArchitecture

struct ImageWithTitleAndSubtitleConfiguration {
    let image: URL?
    let title: NSAttributedString
    let subtitle: NSAttributedString?
}

extension ImageWithTitleAndSubtitleConfiguration {
    init(user: User) {
        self.image = user.image
        self.title = user.name.subtitle()
        self.subtitle = nil
    }
}

final class ImageWithTitleAndSubtitle: UIView, Component {
    private let wrapperStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .center
        stackview.axis = .vertical
        stackview.spacing = Grid * 0.8
        return stackview
    }()
    
    private let contentStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .center
        stackview.axis = .vertical
        stackview.spacing = Grid * 0.5
        return stackview
    }()
    
    private let imageView: UIImageView
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textAlignment = .center
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textAlignment = .center
        return label
    }()
    
    init(imageView: UIImageView) {
        self.imageView = imageView
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: ImageWithTitleAndSubtitleConfiguration) {
        self.imageView.kf.setImage(with: configuration.image)
        self.titleLabel.attributedText = configuration.title
        self.detailLabel.isHidden = true
        self.wrapperStackView.axis = .horizontal
        self.contentStackView.alignment = .leading
    }
    
    private func customizeInterface() {
        self.backgroundColor = .clear
        self.addSubviews()
        self.addConstraints()
    }
    
    private func addSubviews() {
        self.wrapperStackView.addArrangedSubview(self.imageView)
        self.wrapperStackView.addArrangedSubview(self.contentStackView)
        self.contentStackView.addArrangedSubview(self.titleLabel)
        self.contentStackView.addArrangedSubview(self.detailLabel)
        self.addSubview(self.wrapperStackView)
    }
    
    private func addConstraints() {
        self.wrapperStackView.makeEdgesEqualToSuperview()
    }
}

final class RoundedImageView: UIImageView {
    init(borderWidth: CGFloat = 2.0, borderColor: UIColor = .white, size: CGSize? = nil) {
        super.init(frame: .zero)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        
        if let size = size {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size.width),
                self.heightAnchor.constraint(equalToConstant: size.height)
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.width * 0.5
    }
}
