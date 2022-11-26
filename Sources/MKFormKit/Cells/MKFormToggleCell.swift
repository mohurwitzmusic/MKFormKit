import UIKit
import Combine

open class MKFormToggleCell: MKFormCell {
    
    open var toggle = UISwitch()
    open var toggleValueChangedHandler: ((MKFormToggleCell) -> Void)?

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
    
    
    @objc func _valueChanged() {
        toggleValueChangedHandler?(self)
    }
    
    
}
