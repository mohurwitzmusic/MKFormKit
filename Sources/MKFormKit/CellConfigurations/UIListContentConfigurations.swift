import UIKit

public extension UIListContentConfiguration {
    
    static func formHeader(title: String, imageSystemName: String? = nil) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.groupedHeader().withText(title)
        content.imageProperties.tintColor = content.textProperties.color
        content.imageProperties.preferredSymbolConfiguration = .init(scale: .small)
        content.imageToTextPadding = 4
        if let imageSystemName {
            content.image = .init(systemName: imageSystemName)
        }
        return content
    }
    
}
