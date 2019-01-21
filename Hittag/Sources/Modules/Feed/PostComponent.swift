import ModuleArchitecture
import UIKit
import Kingfisher

struct User: Codable {
    let name: String
    let image: URL
}

struct Post: Codable {
    let text: String
    let image: URL
    let hittags: [Hittag]
    let user: User
}

struct Hittag: Codable {
    let name: String
}

struct PostHeaderConfiguration {
    let post: Post
    
    var userName: NSAttributedString {
        return self.post.user.name.subtitle()
    }
}

struct PostFooterConfiguration {
    let hittagConfigurations: [BadgeConfiguration]
}

struct PostConfiguration {
    let headerConfiguration: PostHeaderConfiguration
    let post: Post
    let footerConfiguration: PostFooterConfiguration
    
    init(post: Post) {
        self.headerConfiguration = PostHeaderConfiguration(post: post)
        self.post = post
        
        let hittagConfigurations = post.hittags.map {
            BadgeConfiguration(text: $0.name.hittag(),
                               backgroundColor: UIColor(r: 242, g: 242, b: 242),
                               cornerRadius: 5)
        }
        self.footerConfiguration = PostFooterConfiguration(hittagConfigurations: hittagConfigurations)
    }
}

final class PostHeaderComponent: UIView, Component {
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: PostHeaderConfiguration) {
        self.imageView.kf.setImage(with: configuration.post.user.image)
        self.titleLabel.attributedText = configuration.userName
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
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 50),
            self.imageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}

final class PostFooterComponent: UIView, Component {
    private let wrapperStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .leading
        stackview.axis = .vertical
        stackview.spacing = Grid
        return stackview
    }()
    
    private let headerStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .leading
        stackview.axis = .horizontal
        stackview.spacing = Grid
        return stackview
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        return button
    }()
    
    private let likeCount: UILabel = {
        let label = UILabel()
        label.attributedText = "10 curtidas".subtitle()
        return label
    }()
    
    private let hittagStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .leading
        stackview.axis = .horizontal
        stackview.spacing = Grid
        return stackview
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: PostFooterConfiguration) {
        self.hittagStackView.render(configurations: configuration.hittagConfigurations, factory: Badge.init)
    }
    
    private func customizeInterface() {
        self.backgroundColor = .clear
        self.addSubviews()
        self.addConstraints()
    }
    
    private func addSubviews() {
        self.headerStackView.addArrangedSubview(self.likeButton)
        self.headerStackView.addArrangedSubview(self.likeCount)
        self.wrapperStackView.addArrangedSubview(self.headerStackView)
        self.wrapperStackView.addArrangedSubview(self.hittagStackView.wrapForHorizontalAlignment())
        self.addSubview(self.wrapperStackView)
    }
    
    private func addConstraints() {
        self.wrapperStackView.makeEdgesEqualToSuperview()
        
        NSLayoutConstraint.activate([
            self.likeButton.heightAnchor.constraint(equalToConstant: 20),
            self.likeButton.widthAnchor.constraint(equalToConstant: 20),
        ])
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}

final class PostComponent: UIView, Component {
    private let wrapperStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .leading
        stackview.axis = .vertical
        return stackview
    }()
    
    private let header: PostHeaderComponent = {
        let header = PostHeaderComponent()
        return header
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let footer: PostFooterComponent = {
        let footer = PostFooterComponent()
        return footer
    }()
    
    func render(configuration: PostConfiguration) {
        self.header.render(configuration: configuration.headerConfiguration)
        self.imageView.kf.setImage(with: configuration.post.image)
        self.footer.render(configuration: configuration.footerConfiguration)
    }
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func customizeInterface() {
        self.backgroundColor = .clear
        self.addSubviews()
        self.addConstraints()
    }
    
    private func addSubviews() {
        self.wrapperStackView.addArrangedSubview(self.header.wrapForPadding(UIEdgeInsets(padding: Grid)))
        self.wrapperStackView.addArrangedSubview(self.imageView)
        self.wrapperStackView.addArrangedSubview(self.footer.wrapForPadding(UIEdgeInsets(padding: Grid * 2)))
        self.addSubview(self.wrapperStackView)
    }
    
    private func addConstraints() {
        self.wrapperStackView.makeEdgesEqualToSuperview()
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 280),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
