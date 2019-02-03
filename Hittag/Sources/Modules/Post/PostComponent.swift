import ModuleArchitecture
import UIKit
import Kingfisher

public struct Challenge: Codable, Hashable {
    let name: String
    let image: URL
}

public struct User: Codable {
    public let id: String
    public let name: String
    public let image: URL?
}

public typealias PostId = String

public struct Post: Codable, Hashable {
    public let id: String
    public let text: String
    public let image: URL
    public let hashtags: [Hashtag]
    public let user: User
    public let numberOfLikes: Int
    
    public var hashValue: Int {
        return self.id.hashValue
    }
    
    public static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PostParameters: Codable {
    let image: Data
    let challenge: Challenge
}

struct Hittag: Codable {
    let name: String
    let image: URL
    let icon: URL
}

public struct Hashtag: Codable {
    public let name: String
}

protocol PostComponentDelegate: AnyObject {
    func didLikePost(post: Post)
    func titleButtonTapped(user: User)
}

struct PostConfiguration {
    let headerConfiguration: ImageWithTitleAndSubtitleConfiguration
    let post: Post
    let footerConfiguration: PostFooterConfiguration
    
    init(post: Post) {
        self.headerConfiguration = ImageWithTitleAndSubtitleConfiguration(user: post.user)
        self.post = post
        self.footerConfiguration = PostFooterConfiguration(post: post)
    }
}

final class PostComponent<Delegate: PostComponentDelegate>: UIView, CellComponent, UIGestureRecognizerDelegate {
    weak var delegate: Delegate?
    
    private var configuration: PostConfiguration?
    
    private let wrapperStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .leading
        stackview.axis = .vertical
        return stackview
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        recognizer.numberOfTapsRequired = 2
        recognizer.delegate = self
        return recognizer
    }()
    
    private lazy var header: ImageWithTitleAndSubtitle = {
        let header = ImageWithTitleAndSubtitle(imageView: RoundedImageView(borderColor: .main, size: .postProfilePicture))
        header.delegate = self
        return header
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var likeView: UIView = {
        let button = UIButton(type: .system)
        button.alpha = 0
        button.tintColor = .white
        button.setImage(UIImage(named: "heart-filled"), for: .normal)
        return button
    }()
    
    private let footer: PostFooterComponent = {
        let footer = PostFooterComponent()
        return footer
    }()
    
    func render(configuration: PostConfiguration) {
        self.header.render(configuration: configuration.headerConfiguration)
        self.imageView.kf.setImage(with: configuration.post.image)
        self.footer.render(configuration: configuration.footerConfiguration)
        self.configuration = configuration
    }
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func customizeInterface() {
        
        self.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }
    
    private func addSubviews() {
        self.wrapperStackView.addArrangedSubview(self.header.wrapForPadding(UIEdgeInsets(padding: Grid)))
        self.wrapperStackView.addArrangedSubview(self.imageView)
        self.wrapperStackView.addArrangedSubview(self.footer.wrapForPadding(UIEdgeInsets(padding: Grid * 2)))
        self.addSubview(self.wrapperStackView)
        self.addSubview(self.likeView)
    }
    
    private func addConstraints() {
        self.wrapperStackView.makeEdgesEqualToSuperview()
        self.likeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 280),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.likeView.heightAnchor.constraint(equalToConstant: 60),
            self.likeView.widthAnchor.constraint(equalToConstant: 60),
            self.likeView.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.likeView.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
        ])
    }
    
    @objc private func didDoubleTap() {
        if let configuration = self.configuration {
            self.delegate?.didLikePost(post: configuration.post)
        }
        
        self.likeView.alpha = 1
        UIView.animate(withDuration: 0.6, animations: {
            self.likeView.layoutIfNeeded()
        })
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.likeView.alpha = 0
            UIView.animate(withDuration: 1, animations: {
                self.likeView.layoutIfNeeded()
            })
        }
    }
}

extension PostComponent: ImageWithTitleAndSubtitleDelegate {
    func titleButtonTapped() {
        if let configuration = self.configuration {
            self.delegate?.titleButtonTapped(user: configuration.post.user)
        }
    }
}
