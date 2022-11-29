import UIKit

/// Use as an alternative to `MKFormColorWellCell` when you want to manually present a `UIColorPickerViewController`.
/// Configure the `colorButtonTappedHandler` to receive an event when the button is tapped, and  present your view controller.

open class MKFormColorButtonCell: MKFormCell {
    
    private let colorWell = UIColorWell()
    
    open var colorButonTappedHandler: ((MKFormColorButtonCell) -> Void)?
    
    open var selectedColor: UIColor? {
        get { colorWell.selectedColor }
        set { colorWell.selectedColor = newValue }
    }
    
    open override func setup() {
        selectionStyle = .none
        accessoryView = colorWell
        colorWell.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recognizeTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    @discardableResult
    open func onColorButtonTapped(_ handler: @escaping ((MKFormColorButtonCell) -> Void)) -> Self {
        self.colorButonTappedHandler = handler
        return self
    }
    
     @objc private func recognizeTapGesture(_ gesture: UITapGestureRecognizer) {
         let tapX = gesture.location(in: self).x
         let isMostlyCoveringColorPicker = tapX >= colorWell.frame.minX
         if isMostlyCoveringColorPicker {
             colorButonTappedHandler?(self)
         }
     }
}
