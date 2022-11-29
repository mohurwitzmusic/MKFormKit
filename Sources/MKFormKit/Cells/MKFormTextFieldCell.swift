import UIKit
import Combine


public class MKFormTextFieldCell: MKFormCell, UITextFieldDelegate {
    
    public enum Configuration {
        case fullWidth
        case accessory(size: AccessoryLayout.Size)
    }
    
    public let configuration: Configuration
    public let textField = UITextField()
    public var textFieldShouldReturnHandler: ((MKFormTextFieldCell) -> Bool)?
    public var textFieldShouldChangeCharactersInRangeHandler: ((MKFormTextFieldCell, NSRange, String) -> Bool)?
    public var textFieldDidEndEditingHandler: ((MKFormTextFieldCell) -> Void)?
    public var textFieldDidBeginEditingHandler: ((MKFormTextFieldCell) -> Void)?
    public var textFieldEditingChangedHandler: ((MKFormTextFieldCell) -> Void)?
    
    public init(_ configuration: Configuration) {
        self.configuration = configuration
        super.init(style: .default, reuseIdentifier: nil)
    }
    

    public required init?(coder: NSCoder) {
        self.configuration = .fullWidth
        super.init(coder: coder)
    }
    
    public override func setup() {
        selectionStyle = .none
        switch configuration {
        case .fullWidth:
            contentView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
            ])
        case .accessory(let size):
            self.accessoryView = textField
            textField.textAlignment = .right
            switch size {
            case .automatic: accessoryLayout.width = .fractional(0.5)
            default: accessoryLayout.width = size
            }
        }
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }


    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        self.textFieldEditingChangedHandler?(self)
    }
    
}


public extension MKFormTextFieldCell {
    
    @discardableResult
    func onTextFieldShouldReturn<T: AnyObject>(target: T, handler: @escaping ((T, MKFormTextFieldCell) -> Bool)) -> Self {
        self.textFieldShouldReturnHandler = { [weak target] cell in
            guard let target else {
                cell.textField.resignFirstResponder()
                return true
            }
            return handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onTextFieldShouldCharactersInRange<T: AnyObject>(target: T, handler: @escaping ((T, MKFormTextFieldCell, NSRange, String) -> Bool)) -> Self {
        self.textFieldShouldChangeCharactersInRangeHandler = { [weak target] cell, range, string in
            guard let target else { return true }
            return handler(target, cell, range, string)
        }
        return self
    }
    
    @discardableResult
    func onTextFieldDidEndEditing<T: AnyObject>(target: T, handler: @escaping ((T, MKFormTextFieldCell) -> Void)) -> Self {
        self.textFieldDidEndEditingHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onTextFieldDidBeginEditing<T: AnyObject>(target: T, handler: @escaping ((T, MKFormTextFieldCell) -> Void)) -> Self {
        self.textFieldDidEndEditingHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
    @discardableResult
    func onTextFieldEditingChanged<T: AnyObject>(target: T, handler: @escaping ((T, MKFormTextFieldCell) -> Void)) -> Self {
        self.textFieldEditingChangedHandler = { [weak target] cell in
            guard let target else { return }
            handler(target, cell)
        }
        return self
    }
    
}

extension MKFormTextFieldCell {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let handler = textFieldShouldReturnHandler {
            return handler(self)
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldShouldChangeCharactersInRangeHandler?(self, range, string) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditingHandler?(self)
    }
}


public extension MKFormTextFieldCell {
    
    convenience init(configuration: Configuration = .fullWidth, placeholder: String?, borderStyle: UITextField.BorderStyle = .none, keyboardType: UIKeyboardType = .default) {
        self.init(configuration)
        self.textField.placeholder = placeholder
        self.textField.borderStyle = borderStyle
        self.textField.keyboardType = keyboardType
    }
    
    static func accessory(title: String, imageSystemName: String? = nil, placeholder: String?, borderStyle: UITextField.BorderStyle = .none, keyboardType: UIKeyboardType = .default) -> MKFormTextFieldCell {
        let cell = MKFormTextFieldCell(configuration: .accessory(size: .automatic),
                                   placeholder: placeholder,
                                   borderStyle: borderStyle,
                                   keyboardType: keyboardType)
        cell.contentConfiguration = UIListContentConfiguration.cell()
            .withText(title)
            .withImage(systemName: imageSystemName ?? "")
        return cell
        
    }
    
}
