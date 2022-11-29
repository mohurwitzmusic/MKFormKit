import UIKit

open class MKFormViewController: UITableViewController {
    
    public typealias Snapshot = NSDiffableDataSourceSnapshot<MKFormSection, UITableViewCell>
    public typealias DiffableDataSource = UITableViewDiffableDataSource<MKFormSection, UITableViewCell>
    
    open lazy var dataSource: DiffableDataSource = {
        let ds = DiffableDataSource(tableView: tableView) { tableView, indexPath, cell in
            return cell
        }
        ds.defaultRowAnimation = .middle
        return ds
    }()
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dataSource.snapshot().sectionIdentifiers[section].header
    }
    
    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        dataSource.snapshot().sectionIdentifiers[section].footer
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = self.tableView.indexPathsForSelectedRows?.first {
            if let coordinator = self.transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }) { (context) in
                    if context.isCancelled {
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: indexPath, animated: animated)
            }
        }
    }

    /// Instead of manually updating the diffable data source yourself, you can use
    /// this convenient method. This method performs additional checks to determine
    /// if the reload should be animated or not.
    
    open func reload(sections: [MKFormSection]) {
        let animated = self.view.window != nil
        dataSource.apply(.init(sections: sections), animatingDifferences: animated)
    }
    
    open func reload(sections: [MKFormSection], animated: Bool) {
        dataSource.apply(.init(sections: sections), animatingDifferences: animated)
    }

}
