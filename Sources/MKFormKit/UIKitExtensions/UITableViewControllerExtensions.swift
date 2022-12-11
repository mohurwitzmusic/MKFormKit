import UIKit

public extension UITableViewController {
    
    func deselectRow(at indexPath: IndexPath, animated: Bool, callDidDeselectRow: Bool) {
        tableView.deselectRow(at: indexPath, animated: animated)
        if callDidDeselectRow {
            tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
        }
    }
    
}
