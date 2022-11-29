import UIKit

open class MKFormButtonCell: MKFormCell {
    
    open var button = UIButton(configuration: .bordered())
    open var buttonTouchDownHandler: ((MKFormButtonCell) -> Void)?
    open var buttonTouchUpInsideHandler: ((MKFormButtonCell) -> Void)?
    open var buttonTouchUpOutsideHandler: ((MKFormButtonCell) -> Void)?
    
    open override func setup() {
        selectionStyle = .none
        accessoryView = button
        button.addTarget(self, action: #selector(_buttonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(_buttonTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(_buttonTouchUpOutside), for: .touchUpOutside)
        button.configuration?.image = .init(systemName: "cloud.sun.fill")
    }

    @objc private func _buttonTouchDown() {
        buttonTouchDownHandler?(self)
    }
    
    @objc private func _buttonTouchUpInside() {
        buttonTouchUpInsideHandler?(self)
    }
    
    @objc private func _buttonTouchUpOutside() {
        buttonTouchUpOutsideHandler?(self)
    }
    
}


public extension MKFormButtonCell {
    
    @discardableResult
    func onButtonTouchDown<T: ObservableObject>(target: T, handler: @escaping ((T, MKFormButtonCell) -> Void)) -> Self {
        self.buttonTouchDownHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onButtonTouchUpInside<T: ObservableObject>(target: T, handler: @escaping ((T, MKFormButtonCell) -> Void)) -> Self {
        self.buttonTouchUpInsideHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onButtonTouchUpOutside<T: ObservableObject>(target: T, handler: @escaping ((T, MKFormButtonCell) -> Void)) -> Self {
        self.buttonTouchUpOutsideHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    
}

public extension MKFormButtonCell {
    
    @discardableResult
    func onButtonTouchDown<T: AnyObject>(target: T, handler: @escaping ((T, MKFormButtonCell) -> Void)) -> Self {
        self.buttonTouchDownHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onButtonTouchUpInside<T: AnyObject>(target: T, handler: @escaping ((T, MKFormButtonCell) -> Void)) -> Self {
        self.buttonTouchUpInsideHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onButtonTouchUpOutside<T: AnyObject>(target: T, handler: @escaping ((T, MKFormButtonCell) -> Void)) -> Self {
        self.buttonTouchUpOutsideHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    
}
