import UIKit

open class MKFormViewController: UITableViewController {
    
    public typealias Snapshot = NSDiffableDataSourceSnapshot<MKFormSection, UITableViewCell>
    public typealias DiffableDataSource = UITableViewDiffableDataSource<MKFormSection, UITableViewCell>
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.defaultRowAnimation = .middle
    }
    
    open lazy var dataSource: DiffableDataSource = .init(tableView: tableView) { tableView, indexPath, cell in
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dataSource.snapshot().sectionIdentifiers[section].header
    }
    
    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        dataSource.snapshot().sectionIdentifiers[section].footer
    }
    
}
