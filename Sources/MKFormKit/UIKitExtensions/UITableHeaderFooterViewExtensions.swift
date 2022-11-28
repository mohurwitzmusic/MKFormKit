import UIKit

public extension UITableViewHeaderFooterView {
    
    convenience init(title: String, imageSystemName: String? = nil) {
        self.init(reuseIdentifier: nil)
        self.contentConfiguration = UIListContentConfiguration.formHeader(title: title, imageSystemName: imageSystemName)
    }
    
}

