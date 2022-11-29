import UIKit

public extension UITableViewHeaderFooterView {
    
    static func formHeader(title: String, imageSystemName: String? = nil) -> MKFormHeaderFooterView {
        let header = MKFormHeaderFooterView()
        header.contentConfiguration = UIListContentConfiguration.formHeader(title: title, imageSystemName: imageSystemName)
        return header
    }
    
}

