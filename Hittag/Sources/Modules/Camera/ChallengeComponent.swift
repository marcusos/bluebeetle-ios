import ModuleArchitecture

protocol ChallengeComponentDelegate: class {
    func didSelectConfiguration(_ configuration: ChallengeItemConfiguration)
}

struct ChallengeConfiguration: Equatable {
    private var configurations: Set<ChallengeItemConfiguration>
    private(set) var selectedConfiguration: ChallengeItemConfiguration? = nil
    
    var items: [ChallengeItemConfiguration] {
        return Array(self.configurations).sorted(by: { $0.index > $1.index })
    }
    
    func with(challenges: [Challenge]) -> ChallengeConfiguration {
        var this = self
        let configurations = challenges.enumerated().map {
            ChallengeItemConfiguration(challenge: $0.element, index: $0.offset)
        }
        this.configurations = Set(configurations)
        return this
    }
    
    func with(selectedItem: ChallengeItemConfiguration) -> ChallengeConfiguration {
        var this = self
        let selectedConfiguration = selectedItem.with(isSelected: true)
        
        if selectedConfiguration == this.selectedConfiguration {
            return this
        }
        
        if let currentlySelected = this.selectedConfiguration {
            this.configurations.remove(currentlySelected)
            this.configurations.insert(currentlySelected.with(isSelected: false))
        }
        
        this.configurations.remove(selectedItem)
        this.configurations.insert(selectedConfiguration)
        this.selectedConfiguration = selectedConfiguration
        return this
    }
    
    init(configurations: Set<ChallengeItemConfiguration>) {
        self.configurations = configurations
        self.selectedConfiguration = nil
    }
}

final class ChallengeComponent: UIView, Component {
    weak var delegate: ChallengeComponentDelegate?
    
    private var dataSource = CollectionViewDataSource<ContainerCollectionViewCell<ChallengeItemComponent>>() {
        didSet {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    private let collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Grid * 2
        layout.minimumInteritemSpacing = Grid * 2
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        collectionView.register(ContainerCollectionViewCell<ChallengeItemComponent>.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        self.customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: self.collectionLayout.itemSize.height)
    }
    
    func render(configuration: ChallengeConfiguration) {
        self.dataSource = .init(configurations: configuration.items)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.contentInset = UIEdgeInsets(left: self.bounds.width * 0.5 - self.collectionLayout.itemSize.width * 0.5)
    }
}

extension ChallengeComponent {
    private func customizeInterface() {
        self.defineSubviews()
        self.defineSubviewsConstraints()
    }
    
    private func defineSubviews() {
        self.addSubview(self.collectionView)
    }
    
    private func defineSubviewsConstraints() {
        self.collectionView.makeEdgesEqualToSuperview()
    }
}

extension ChallengeComponent: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let configuration = self.dataSource.configurations[""]?[indexPath.row] {
            self.delegate?.didSelectConfiguration(configuration)
        }
    }
}
