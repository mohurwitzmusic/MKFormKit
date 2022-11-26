import UIKit
import Combine

open class MKFormSliderCell: MKFormCell {
    
    public let slider = UISlider()
    
    open var sliderValueChangedHandler: ((MKFormSliderCell) -> Void)?
    open var sliderTouchesEndedHandler: ((MKFormSliderCell) -> Void)?
    open var cancellable: AnyCancellable?
    
    open override func setup() {
        selectionStyle = .none
        contentView.addSubview(slider)
        slider.constrainToLayoutGuide(contentView.layoutMarginsGuide)
        slider.addTarget(self, action: #selector(_sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(_sliderTouchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(_sliderTouchUp), for: .touchUpOutside)
    }
    
    
    public convenience init<T: ObservableObject>(observing object: T, handler: @escaping ((T, MKFormSliderCell) -> Void)) {
        self.init()
        self.cancellable = object.objectWillChange
            .sink { [weak object] _ in
                guard let object else { return }
                handler(object, self)
            }
    }
    
    
    @discardableResult
    open func onValueChanged<T: AnyObject>(target: T, handler: @escaping ((T, MKFormSliderCell) -> Void)) -> Self {
        self.sliderValueChangedHandler =  { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    open func onTouchesEnded<T: AnyObject>(target: T, handler: @escaping ((T, MKFormSliderCell) -> Void)) -> Self {
        self.sliderTouchesEndedHandler =  { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    open func configuration(_ handler: @escaping((MKFormSliderCell, UICellConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { cell, state in
            handler(cell as! MKFormSliderCell, state)
        }
        return self
    }
    
    @objc private func _sliderValueChanged() {
        sliderValueChangedHandler?(self)
    }
    
    @objc private func _sliderTouchUp() {
        sliderTouchesEndedHandler?(self)
    }
    
}
