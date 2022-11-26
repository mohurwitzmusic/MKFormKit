import UIKit
import Combine

open class MKFormColorPickerCell: MKFormCell {
    
    private var lastSentColor: UIColor?
    public let colorWell = UIColorWell()
    public var cancellable: AnyCancellable?
    public var colorWellValueChangedHandler: ((MKFormColorPickerCell) -> Void)?
    
    open override func setup() {
        selectionStyle = .none
        accessoryView = colorWell
        colorWell.addTarget(self, action: #selector(_colorWellValueChanged), for: .valueChanged)
    }

    @discardableResult
    open func onObjectWillChange<T: ObservableObject>(_ object: T, handler: @escaping ((T, MKFormColorPickerCell) -> Void)) -> Self {
        self.cancellable = object.objectWillChange
            .sink {  [weak object, weak self] _ in
                guard let object, let self else { return }
                handler(object, self)
            }
        return self
    }
 
    public convenience init<T: ObservableObject>(observing object: T, handler: @escaping ((T, MKFormColorPickerCell) -> Void)) {
        self.init(style: .default, reuseIdentifier: nil)
        cancellable = object.objectWillChange.sink { [weak object, weak self] _ in
            if let object, let self {
                handler(object, self)
            }
        }
    }
    
    @discardableResult
    open func onColorWellValueChanged<T: AnyObject>(target: T, handler: @escaping ((T, MKFormColorPickerCell) -> Void)) -> Self {
        self.colorWellValueChangedHandler =  { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    
    @discardableResult
    open func onConfigurationUpdate<T: AnyObject>(source: T, _ handler: @escaping((T, MKFormColorPickerCell, UICellConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak source] cell, state in
            guard let source else { return }
            handler(source, cell as! MKFormColorPickerCell, state)
        }
        return self
    }
    
    @objc private func _colorWellValueChanged() {
        guard let color = colorWell.selectedColor else { return }
        if let lastSentColor, lastSentColor.isAlmostEqual(to: color) { return }
        lastSentColor = colorWell.selectedColor
        colorWellValueChangedHandler?(self)
    }
    
}


fileprivate extension UIColor {
    
    func isAlmostEqual(to other: UIColor) -> Bool {
        return self.getRGBA().isAlmostEqual(to: other.getRGBA())
    }
    
    private func getRGBA() -> RGBA {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(1.0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return .init(r: r, g: g, b: b, a: a)
    }
    
    private struct RGBA: Equatable {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat
        
        func isAlmostEqual(to other: RGBA) -> Bool {
            let delta = CGFloat(0.01)
            if abs(self.r - other.r) < delta,
               abs(self.g - other.g) < delta,
               abs(self.b - other.b) < delta,
               abs(self.a - other.a) < delta {
                return true
            }
            return false
        }
    }
}
