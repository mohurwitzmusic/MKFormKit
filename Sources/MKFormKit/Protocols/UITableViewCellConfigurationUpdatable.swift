import UIKit

public protocol UITableViewCellConfigurationUpdatable where Self : UITableViewCell {
    var configurationUpdateHandler: UITableViewCell.ConfigurationUpdateHandler? { get set }
}

public extension UITableViewCellConfigurationUpdatable {
    
    @discardableResult
    func setConfigurationUpdateHandler(_ handler: @escaping ((Self, UICellConfigurationState) -> Void)) -> Self {
        configurationUpdateHandler = { cell, state in
            handler(cell as! Self, state)
        }
        return self
    }
    
    @discardableResult
    func setConfigurationUpdateHandler<T: AnyObject>(target: T, _ handler: @escaping ((T, Self, UICellConfigurationState) -> Void)) -> Self {
        configurationUpdateHandler = { [weak target] cell, state in
            guard let target else { return }
            handler(target, cell as! Self, state)
        }
        return self
    }
    
    
}

extension UITableViewCell: UITableViewCellConfigurationUpdatable { }

