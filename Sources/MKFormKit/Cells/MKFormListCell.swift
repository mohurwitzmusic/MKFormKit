import UIKit
import Combine


open class MKFormListCell: MKFormCell {
        
    public convenience init(text: String, secondaryText: String? = nil, imageSystemName: String? = nil, accessory: UITableViewCell.AccessoryType = .none) {
        self.init(style: .default, reuseIdentifier: nil)
        self.contentConfiguration = UIListContentConfiguration.cell()
            .withText(text)
            .withSecondaryText(secondaryText ?? "")
            .withImage(systemName: imageSystemName ?? "")
        self.accessoryType = accessory
    }
    
}
