import UIKit

public extension UIListContentConfiguration {
    
    static func formHeader(title: String, imageSystemName: String? = nil) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.groupedHeader().withText(title)
        if let imageSystemName {
            content = content.withImage(systemName: imageSystemName)
                .withImageTintColor(content.textProperties.color)
                .withSymbolConfiguration(.init(scale: .small))
                .withImageToTextPadding(4)
        }
        return content
    }
    
}
