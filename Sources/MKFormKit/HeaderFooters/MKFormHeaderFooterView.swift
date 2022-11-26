import UIKit
import Combine

open class MKFormHeaderFooterView: UITableViewHeaderFooterView {
    
    public var cancellable: AnyCancellable?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    /// Override to perform any configuration after initialization. The default implementation does nothing.
    
    open func setup() { }

    @discardableResult
    open func updateConfiguration<T: AnyObject>(source: T, _ handler: @escaping ((T, UITableViewHeaderFooterView, UIViewConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak source] view, state in
            guard let source else { return }
            handler(source, view, state)
        }
        return self
    }
    
    @discardableResult
    public func onObjectWillChange<T: ObservableObject>(_ object: T, handler:  @escaping ((T, MKFormHeaderFooterView) -> Void)) -> Self {
        cancellable = object.objectWillChange
            .sink { [weak self, weak object] _ in
                guard let self, let object else { return }
                handler(object, self)
            }
        return self
    }
    
    
}

public extension MKFormHeaderFooterView {
    
    convenience init(text: String, imageSystemName: String? = nil) {
        self.init(reuseIdentifier: nil)
        var content = UIListContentConfiguration.groupedHeader().withText(text)
        if let imageSystemName {
            content = content.withImage(systemName: imageSystemName)
                .withImageTintColor(content.textProperties.color)
                .withSymbolConfiguration(.init(scale: .small))
                .withImageToTextPadding(4)
        }
        self.contentConfiguration = content
    }
    
}

