import UIKit
import Combine

open class MKFormSliderCell: MKFormCell {
    
    public let slider = UISlider()
    
    open var sliderValueChangedHandler: ((MKFormSliderCell) -> Void)?
    open var sliderTouchesEndedHandler: ((MKFormSliderCell) -> Void)?
    
    open override func setup() {
        selectionStyle = .none
        contentView.addSubview(slider)
        slider.constrainToLayoutGuide(contentView.layoutMarginsGuide)
        slider.addTarget(self, action: #selector(_sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(_sliderTouchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(_sliderTouchUp), for: .touchUpOutside)
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

    @objc private func _sliderValueChanged() {
        sliderValueChangedHandler?(self)
    }
    
    @objc private func _sliderTouchUp() {
        sliderTouchesEndedHandler?(self)
    }
    
}
