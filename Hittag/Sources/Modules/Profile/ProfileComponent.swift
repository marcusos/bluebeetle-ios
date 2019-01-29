import UIKit
import ModuleArchitecture
import Kingfisher

final class HittagImageComponent: UIView, Component {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let hittagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render(configuration: HittagImageConfiguration) {
        self.imageView.kf.setImage(with: configuration.image)
    }
    
    private func customizeInterface() {
        
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.defineSubviews()
        self.defineSubviewsConstraints()
    }
    
    private func defineSubviews() {
        self.addSubview(self.imageView)
        self.addSubview(self.hittagImageView)
    }
    
    private func defineSubviewsConstraints() {
        self.imageView.makeEdgesEqualToSuperview()
        self.hittagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.hittagImageView.heightAnchor.constraint(equalToConstant: Grid * 3),
            self.hittagImageView.widthAnchor.constraint(equalToConstant: Grid * 3),
            self.hittagImageView.bottomSafeAnchor.constraint(equalTo: self.bottomSafeAnchor, constant: -Grid * 0.5),
            self.hittagImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Grid * 0.5),
        ])
    }
}

protocol ProfileCompoentDelegate: AnyObject {
    func didSelectPost(post: Post)
}

final class ProfileComponent: UIView {
    weak var delegate: ProfileCompoentDelegate?
    
    private let wrapperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let header: ImageWithTitleAndSubtitle = {
        let header = ImageWithTitleAndSubtitle(imageView: RoundedImageView(borderWidth: 3, borderColor: .main, size: .profilePicture))
        header.setContentCompressionResistancePriority(.required, for: .vertical)
        return header
    }()
    
    private var dataSource = CollectionViewDataSource<ContainerCollectionViewCell<HittagImageComponent>>() {
        didSet {
            self.collectionView.dataSource = self.dataSource
        }
    }
    
    private let collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        collectionView.register(ContainerCollectionViewCell<HittagImageComponent>.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    init() {

        super.init(frame: .zero)
        self.customizeInterface()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionLayout.itemSize = CGSize(width: self.frame.width * 0.3333,
                                                height: self.frame.width * 0.3333)
    }
}

extension ProfileComponent {

    func render(configuration: ProfileConfiguration) {
        self.header.render(configuration: configuration.headerConfiguration)
        self.dataSource = .init(configurations: configuration.hittagConfigurations)
    }
}

extension ProfileComponent {

    private func customizeInterface() {

        self.backgroundColor = .white
        self.defineSubviews()
        self.defineSubviewsConstraints()
    }

    private func defineSubviews() {
        self.wrapperStackView.addArrangedSubview(self.header.wrapForPadding(UIEdgeInsets(padding: Grid * 2)))
        self.wrapperStackView.addArrangedSubview(self.collectionView)
        self.addSubview(self.wrapperStackView)
    }

    private func defineSubviewsConstraints() {
        self.wrapperStackView.makeEdgesEqualToSuperview(usesSafeaArea: true)
    }
}

extension ProfileComponent: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let configuration = self.dataSource.configurations[""]?[indexPath.row] else { return }
        self.delegate?.didSelectPost(post: configuration.post)
    }
}
