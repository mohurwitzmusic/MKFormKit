import UIKit

open class MKPickerFormViewController<T: Hashable>: UICollectionViewController {
    
    open var form: MKPickerForm<T> {
        didSet {
            refreshStaticContent()
            reloadCells(animated: false)
        }
    }
    
    open var selectionConfirmationHandler: ((MKPickerForm<T>) -> ())?
    
    public enum SectionIdentifier: Hashable {
        case main
    }
    
    public typealias ItemIdentifier = MKPickerForm<T>.ListItem
    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    public typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>
    open var diffableDataSource: DiffableDataSource!
    
    //MARK: - Initialization
    
    public init(form: MKPickerForm<T>) {
        self.form = form
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfig.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        super.init(collectionViewLayout: layout)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureNavigationBar()
        configureToolbar()
        refreshStaticContent()
        reloadCells(animated: false)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        selectionConfirmationHandler?(form)
        super.viewWillDisappear(animated)
    }
    
    //MARK: - CollectionViewDelegate

    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let itemIdentifier = diffableDataSource.itemIdentifier(for: indexPath) {
            form.selectItem(itemIdentifier.item)
        }
        
    }
    
    //MARK: - Configuration
        
    open func configureDataSource() {
        let cell = listCellRegistration()
        self.diffableDataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: itemIdentifier)
        }
    }
    
    open func configureNavigationBar() { }
    
    open func configureToolbar() { }

    //MARK: - Cell Registrations

    open func listCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, ItemIdentifier> {
        .init { [weak self] cell, indexPath, itemIdentifier in
            guard let form = self?.form else { return }
            cell.contentConfiguration = itemIdentifier.content.updated(for: cell.configurationState)
            if form.selections.contains(itemIdentifier.item) {
                cell.accessories = [.checkmark()]
            } else {
                cell.accessories = []
            }
        }
    }


    //MARK: - Snapshots
    
    open func newSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(form.listItems, toSection: .main)
        return snapshot
    }


    //MARK: - Drawing
    
    open func refreshStaticContent() {
        title = form.title
    }
    
    open func reloadCells(animated: Bool) {
        if #available(iOS 15, *) {
            if animated {
                self.diffableDataSource.apply(newSnapshot(), animatingDifferences: true)
            } else {
                self.diffableDataSource.applySnapshotUsingReloadData(newSnapshot())
            }
        } else {
            self.diffableDataSource.apply(newSnapshot(), animatingDifferences: animated)
        }
    }
    

    
}
