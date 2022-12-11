import UIKit
import Combine

open class MKFormColorWellCell: MKFormCell {
    
    private var lastSentColor: UIColor?
    private let tapGesture = UITapGestureRecognizer()
    public var colorWell = UIColorWell()
    public var colorWellValueChangedHandler: ((MKFormColorWellCell) -> Void)?
 
    
    open override func setup() {
        selectionStyle = .none
        accessoryView = colorWell
        colorWell.supportsAlpha = false
        colorWell.addTarget(self, action: #selector(_colorWellValueChanged), for: .valueChanged)
    }
    

    convenience init(title: String, subtitle: String? = nil, systemImage: String? = nil, supportsAlpha: Bool = false) {
        self.init(title: title, subtitle: subtitle, systemImage: systemImage)
        self.colorWell.supportsAlpha = supportsAlpha
    }
    
    @objc private func _colorWellValueChanged() {
        guard let color = colorWell.selectedColor else { return }
        if let lastSentColor, lastSentColor.isAlmostEqual(to: color) { return }
        lastSentColor = colorWell.selectedColor
        colorWellValueChangedHandler?(self)
    }

}

public extension MKFormColorWellCell {
    
    @discardableResult
    func onColorWellValueChanged<T: AnyObject>(target: T, handler: @escaping ((T, MKFormColorWellCell) -> Void)) -> Self {
        self.colorWellValueChangedHandler =  { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
}

public extension MKFormColorWellCell {
    
    @discardableResult
    func onColorWellValueChanged<T: ObservableObject>(target: T, handler: @escaping ((T, MKFormColorWellCell) -> Void)) -> Self {
        self.colorWellValueChangedHandler =  { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
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

