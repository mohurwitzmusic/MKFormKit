import UIKit

public extension UITableViewHeaderFooterView {
    
    static func mkFormHeader(title: String, imageSystemName: String? = nil) -> MKFormHeaderFooterView {
        let header = MKFormHeaderFooterView()
        header.contentConfiguration = UIListContentConfiguration.mkFormHeader(title: title, imageSystemName: imageSystemName)
        return header
    }
    
}

