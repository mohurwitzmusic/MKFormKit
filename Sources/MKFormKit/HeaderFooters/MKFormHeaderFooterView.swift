import UIKit
import Combine

open class MKFormHeaderFooterView: UITableViewHeaderFooterView, UpdatesConfigurationOnObjectWillChange {
    
    public var observedObject: AnyCancellable?
    
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

