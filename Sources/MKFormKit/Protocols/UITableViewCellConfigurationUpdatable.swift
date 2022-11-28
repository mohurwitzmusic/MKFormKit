import UIKit

public protocol UITableViewCellConfigurationUpdatable where Self : UITableViewCell {
    var configurationUpdateHandler: UITableViewCell.ConfigurationUpdateHandler? { get set }
}

public extension UITableViewCellConfigurationUpdatable {
    
    @discardableResult
    func onConfigurationUpdate(_ handler: @escaping ((Self, UICellConfigurationState) -> Void)) -> Self {
        configurationUpdateHandler = { cell, state in
            handler(cell as! Self, state)
        }
        return self
    }
    
}

extension UITableViewCell: UITableViewCellConfigurationUpdatable { }

