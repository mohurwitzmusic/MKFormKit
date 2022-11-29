import UIKit

public extension UITableViewHeaderFooterView {
    
    static func formHeader(title: String, imageSystemName: String? = nil) -> MKFormHeaderFooterView {
        let header = MKFormHeaderFooterView()
        header.contentConfiguration = UIListContentConfiguration.formHeader(title: title, imageSystemName: imageSystemName)
        return header
    }
    
    static func formHeader(title: String, image: UIImage? = nil) -> MKFormHeaderFooterView {
        let header = MKFormHeaderFooterView()
        var content = UIListContentConfiguration.formHeader(title: title)
        content.image = image
        header.contentConfiguration = content
        return header
    }
}

