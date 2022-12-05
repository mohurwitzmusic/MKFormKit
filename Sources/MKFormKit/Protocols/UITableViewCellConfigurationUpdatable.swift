import UIKit

public protocol UITableViewCellConfigurationUpdatable where Self : UITableViewCell {
    var configurationUpdateHandler: UITableViewCell.ConfigurationUpdateHandler? { get set }
}

public extension UITableViewCellConfigurationUpdatable {
    
    /// Sets the cell's `configurationUpdateHandler`.
    ///
    /// - Parameters:
    ///     - handler: the cell's `contentConfigurationHandler`
    ///  - Returns: the conforming type.
    
    @discardableResult
    func setConfigurationUpdateHandler(_ handler: @escaping ((Self, UICellConfigurationState) -> Void)) -> Self {
        configurationUpdateHandler = { cell, state in
            handler(cell as! Self, state)
        }
        return self
    }
    
    /// Sets the cell's `configurationUpdateHandler` including an object to be passed in.
    ///
    /// The closure captures a weak reference to the target.
    ///
    ///  - Parameters:
    ///     - target: the object to pass into the `contentConfigurationHandler`.
    ///     - handler: the cell's `contentConfigurationHandler`, including the `target` passed into the block.
    ///  - Returns: the conforming type.
    ///
    
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

