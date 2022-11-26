import UIKit
import Combine


open class MKFormListCell: MKFormCell {
    
    public var cancellable: AnyCancellable?
    
    public convenience init(text: String, secondaryText: String? = nil, imageSystemName: String? = nil, accessory: UITableViewCell.AccessoryType = .none) {
        self.init(style: .default, reuseIdentifier: nil)
        self.contentConfiguration = UIListContentConfiguration.cell()
            .withText(text)
            .withSecondaryText(secondaryText ?? "")
            .withImage(systemName: imageSystemName ?? "")
        self.accessoryType = accessory
    }
    
    @discardableResult
    public func onObjectWillChange<T: ObservableObject>(_ object: T, handler: @escaping ((T, MKFormListCell) -> Void)) -> Self {
        cancellable = object.objectWillChange.sink { [weak self, weak object] _ in
            guard let self, let object else { return }
            handler(object, self)
        }
        return self
    }
    
    @discardableResult
    public func onConfigurationUpdate<T: AnyObject>(source: T, handler: @escaping ((T, MKFormListCell) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak source, weak self] _, _ in
            guard let self, let source else { return }
            handler(source, self)
        }
        return self
    }
    
    
    
}
