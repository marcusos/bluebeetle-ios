import ModuleArchitecture

struct PostFooterConfiguration {
    let likesText: NSAttributedString
    let hittagConfigurations: [BadgeConfiguration]
    
    init(post: Post) {
        self.hittagConfigurations = post.hashtags.map {
            BadgeConfiguration(text: $0.name.hashtag(),
                               backgroundColor: .badge,
                               cornerRadius: 5)
        }
        self.likesText = "\(post.numberOfLikes) curtidas".subtitle()
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
        label.attributedText = "...".subtitle()
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
        self.likeCount.attributedText = configuration.likesText
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
