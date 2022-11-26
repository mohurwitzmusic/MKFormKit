import UIKit

public protocol MKFormListCellConfigurable: UITableViewCell {
    
}

public extension MKFormListCellConfigurable {
    
    @discardableResult
    func onConfigurationUpdate<T: AnyObject>(source: T, handler: @escaping ((T, Self, UICellConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak source, weak self] _, state in
            guard let source else { return }
            guard let self else { return }
            handler(source, self, state)
        }
        return self
    }
    
}
