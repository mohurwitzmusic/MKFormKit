import UIKit
import Combine


open class MKFormCell: UITableViewCell, CanSubscribeToEvents {
        
    open var cancellables = Set<AnyCancellable>()

    open override var isUserInteractionEnabled: Bool {
        didSet {
            accessoryView?.isUserInteractionEnabled = isUserInteractionEnabled
            if let accessoryView = accessoryView as? UIControl {
                accessoryView.isEnabled = isUserInteractionEnabled
            }
            if let hitTestingView = hitTestingView as? UIControl {
                hitTestingView.isEnabled = isUserInteractionEnabled
                hitTestingView.isUserInteractionEnabled = isUserInteractionEnabled
            }
        }
    }
    
    /// Use to define the size of an accessory. `layoutSubviews` checks
    /// to see if an `accessoryView` is set and uses `accessoryLayout` to
    /// calculate its size. The view will be centered vertically.
    
    public struct AccessoryLayout: Hashable, Sendable {
        public enum Size: Hashable, Sendable {
            case fractional(CGFloat)
            case fixed(CGFloat)
            case automatic
        }
        public var width = Size.automatic
        public var height = Size.automatic
        public var maxWidth: CGFloat?
        public var maxHeight: CGFloat?
    }
    

    /// The layout of the accessory to use during `layoutSubviews`. Setting this
    /// casuses `layoutSubviews` to be called.
    
    open var accessoryLayout = AccessoryLayout() {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Override to perform any setup after initialization. The default implementation does nothing.
    
    open func setup() { }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutAccessoryIfNeeded()
    }

    private func layoutAccessoryIfNeeded() {
        guard let accessoryView else { return }
        let width = calculateAccessoryWidth()
        let height = calculateAccessoryHeight()
        let x = bounds.maxX - width - directionalLayoutMargins.leading
        let y = bounds.midY - height/2
        accessoryView.frame = .init(x: x, y: y, width: width, height: height)
    }
    
    private func calculateAccessoryWidth() -> CGFloat {
        guard let accessoryView else { return 0 }
        let automaticSize = accessoryView.sizeThatFits(accessoryView.frame.size)
        var width: CGFloat
        switch accessoryLayout.width {
        case .automatic:
            width = automaticSize.width
        case .fixed(let cGFloat):
            width = cGFloat
        case .fractional(let cGFloat):
            width = bounds.width * cGFloat
        }
        if let max = accessoryLayout.maxWidth {
            width = min(max, width)
        }
        let contentViewWidth = bounds.width - directionalLayoutMargins.leading - directionalLayoutMargins.trailing
        return min(contentViewWidth, width)
    }
    
    private func calculateAccessoryHeight() -> CGFloat {
        guard let accessoryView else { return 0 }
        let automaticSize = accessoryView.sizeThatFits(accessoryView.frame.size)
        var height: CGFloat
        switch accessoryLayout.height {
        case .automatic:
            height = automaticSize.height
        case .fractional(let cGFloat):
            height = bounds.height * cGFloat
        case .fixed(let cGFloat):
            height = cGFloat
        }
        if let max = accessoryLayout.maxHeight {
            height = min(height, max)
        }
        let contentViewHeight = bounds.height - 12
        return min(contentViewHeight, height)
    }
    
    /// Set the hit testing view when the cell's content manages a sub-control that should consume touches.
    
    open weak var hitTestingView: UIView?
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitTestingView {
            if hitTestingView.frame.contains(point) {
                return hitTestingView
            }
            return nil
        }
        return super.hitTest(point, with: event)
    }
    
    
}

public extension MKFormCell {
    
    convenience init(title: String, subtitle: String? = nil, systemImage: String? = nil) {
        self.init(style: .default, reuseIdentifier: nil)
        self.contentConfiguration = self.defaultContentConfiguration()
            .withText(title)
            .withSecondaryText(subtitle ?? "")
            .withImage(systemName: systemImage ?? "")
    }
    
    
    @available(*, unavailable, renamed: "MKFormCell.init(title:subtitle:systemImage:)")
    convenience init(title: String, subtitle: String? = nil, imageSystemName: String? = nil) {
        self.init(title: title, subtitle: subtitle, systemImage: imageSystemName)
    }

}





