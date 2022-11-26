import UIKit
import Combine

open class MKFormToggleCell: MKFormCell {
    
    open var toggle = UISwitch()
    open var toggleValueChangedHandler: ((MKFormToggleCell) -> Void)?
    open var cancellable: AnyCancellable?

    open override func setup() {
        selectionStyle = .none
        accessoryView = toggle
        toggle.addTarget(self, action: #selector(_valueChanged), for: .valueChanged)
    }

    @discardableResult
    open func onToggleValueChanged<T: AnyObject>(target: T, handler: @escaping ((T, MKFormToggleCell) -> Void)) -> Self {
        self.toggleValueChangedHandler =  { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    open func onObjectWillChange<T: ObservableObject>(_ object: T, handler: @escaping ((T, MKFormToggleCell) -> Void)) -> Self {
        self.cancellable = object.objectWillChange
            .sink {  [weak object, weak self] _ in
                guard let object, let self else { return }
                handler(object, self)
            }
        return self
    }
    

    @discardableResult
    open func onConfigurationUpdate<T: AnyObject>(source: T, _ handler: @escaping((T, MKFormToggleCell, UICellConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak source] cell, state in
            guard let source else { return }
            handler(source, cell as! MKFormToggleCell, state)
        }
        return self
    }
    
    @objc func _valueChanged() {
        toggleValueChangedHandler?(self)
    }
    
    
}
