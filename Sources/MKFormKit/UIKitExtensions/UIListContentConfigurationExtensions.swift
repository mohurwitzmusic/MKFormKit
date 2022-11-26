import UIKit

public extension UIListContentConfiguration {

    @discardableResult
    func withText(_ text: String) -> Self {
        var copy = self
        copy.text = text
        return copy
    }
    
    @discardableResult
    func withSecondaryText(_ text: String) -> Self {
        var copy = self
        copy.secondaryText = text
        return copy
    }
    
    @discardableResult
    func withImage(systemName: String) -> Self {
        var copy = self
        copy.image = .init(systemName: systemName)
        return copy
    }
    
    @discardableResult
    func withImage(_ image: UIImage?) -> Self {
        var copy = self
        copy.image = image
        return copy
    }
    
    @discardableResult
    func withImageTintColor(_ color: UIColor) -> Self {
        var copy = self
        copy.imageProperties.tintColor = color
        return copy
    }
    
    @discardableResult
    func withPrefersSideBySideAndSecondaryText(_ prefers: Bool) -> Self {
        var copy = self
        copy.prefersSideBySideTextAndSecondaryText = prefers
        return copy
    }
    
    @discardableResult
    func withSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> Self {
        var copy = self
        copy.imageProperties.preferredSymbolConfiguration = configuration
        return copy
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        var copy = self
        copy.textProperties.color = color
        return copy
    }
    
    @discardableResult
    func withSecondaryTextColor(_ color: UIColor) -> Self {
        var copy = self
        copy.secondaryTextProperties.color = color
        return copy
    }
    
    @discardableResult
    func withFont(_ font: UIFont) -> Self {
        var copy = self
        copy.textProperties.font = font
        return copy
    }
    
    @discardableResult
    func withSecondaryFont(_ font: UIFont) -> Self {
        var copy = self
        copy.secondaryTextProperties.font = font
        return copy
    }
    
    @discardableResult
    func withImageToTextPadding(_ padding: CGFloat) -> Self {
        var copy = self
        copy.imageToTextPadding = padding
        return copy
    }
    
    @discardableResult
    func withLayoutMargins(_ margins: NSDirectionalEdgeInsets) -> Self {
        var copy = self
        copy.directionalLayoutMargins = margins
        return copy
    }
    
    @discardableResult
    func withPreferredSymbolConfiguration(_ config: UIImage.SymbolConfiguration) -> Self {
        var copy = self
        copy.imageProperties.preferredSymbolConfiguration = config
        return copy
    }
    
    @discardableResult
    func withTopMargin(_ margin: CGFloat) -> Self {
        var copy = self
        copy.directionalLayoutMargins.top = margin
        return copy
    }
    
    @discardableResult
    func withLeadingMargin(_ margin: CGFloat) -> Self {
        var copy = self
        copy.directionalLayoutMargins.leading = margin
        return copy
    }
    
    @discardableResult
    func withTrailingMargin(_ margin: CGFloat) -> Self {
        var copy = self
        copy.directionalLayoutMargins.trailing = margin
        return copy
    }
    
    @discardableResult
    func withBottomMargin(_ margin: CGFloat) -> Self {
        var copy = self
        copy.directionalLayoutMargins.bottom = margin
        return copy
    }
}
