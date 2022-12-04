import UIKit


/// A `UITableViewCell` that manages a custom `UIContentConfiguration` which provides a secondary, right-aligned image.
///
/// Call `contentConfiguration(decorating:)` directy on the cell to get the custom configuration, or initialize the configuration with `MKFormSecondaryImageCell.Configuration(decorating:) to use it in any cell`

open class MKFormSecondaryImageCell: MKFormCell {

    open func contentConfiguration(decorating configuration: UIListContentConfiguration) -> MKFormSecondaryImageCell.Configuration {
        .init(decorating: configuration)
    }

}


extension MKFormSecondaryImageCell {
    
    /// A `UIContentConfiguration` that decorates a `UIListContentConfiguration`, additionally
    /// supplying a secondary, right-aligned image.
    
    public struct Configuration: UIContentConfiguration, Equatable {
        
        /// The default `UIListContentConfiguration` for the cell to decorate. The decorated
        /// content configuration will be aligned to the left of the cell.
        
        public var decoratee: UIListContentConfiguration
        
        /// The content configuration's secondary, right-aligned image.

        public var secondaryImage: UIImage?
        
        /// Properties that affect the list content configuration’s secondary image.
        
        public var secondaryImageProperties: UIListContentConfiguration.ImageProperties
        
        /// The padding between the secondary image and the cell's decorated content configuration.
        
        public var secondaryImagePadding: CGFloat = 8
        
        public init(decorating decoratee: UIListContentConfiguration) {
            self.decoratee = decoratee
            self.secondaryImageProperties = decoratee.imageProperties
        }
        
        public func makeContentView() -> UIView & UIContentView {
            MKFormSecondaryImageCell.ContentView(customConfiguration: self)
        }
        
        public func updated(for state: UIConfigurationState) -> MKFormSecondaryImageCell.Configuration {
            var copy = self
            copy.decoratee = decoratee.updated(for: state)
            if secondaryImageProperties.tintColor == nil {
                copy.secondaryImageProperties.tintColor = decoratee.imageProperties.tintColor
            }
            if secondaryImage != nil && secondaryImageProperties.reservedLayoutSize.width < 1 {
                copy.secondaryImageProperties.reservedLayoutSize.width = 24
            }
            return copy
        }
    }
    
}

fileprivate extension MKFormSecondaryImageCell {
    
    class ContentView: UIView, UIContentView {
        
        var customConfiguration: MKFormSecondaryImageCell.Configuration
        let hStack = UIStackView()
        let contentContainerView = UIView()
        let imageView = UIImageView()
        var imageWidthConstraint: NSLayoutConstraint?
        
        override var intrinsicContentSize: CGSize {
            .init(width: UIView.noIntrinsicMetric, height: 44)
        }
        
        var configuration: UIContentConfiguration {
            get { customConfiguration }
            set {
                if let newConfig = newValue as? MKFormSecondaryImageCell.Configuration,
                   newConfig != customConfiguration {
                    self.customConfiguration = newConfig
                    update()
                }
            }
        }
        
        init(customConfiguration: MKFormSecondaryImageCell.Configuration) {
            self.customConfiguration = customConfiguration
            super.init(frame: .init(x: 0, y: 0, width: 1000, height: 44))
            addSubview(hStack)
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.axis = .horizontal
            hStack.addArrangedSubview(contentContainerView)
            hStack.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                hStack.topAnchor.constraint(equalTo: topAnchor),
                hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            ])
            imageWidthConstraint?.isActive = true
            imageView.contentMode = .scaleAspectFit
            update()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func update() {
            hStack.spacing = customConfiguration.secondaryImagePadding
            contentContainerView.subviews.first?.removeFromSuperview()
            let uiListContent = customConfiguration.decoratee.makeContentView()
            contentContainerView.addSubview(uiListContent)
            uiListContent.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                uiListContent.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
                uiListContent.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
                uiListContent.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
                uiListContent.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
            ])
            imageView.image = customConfiguration.secondaryImage
            imageView.tintColor = customConfiguration.secondaryImageProperties.tintColor
            imageWidthConstraint?.constant =  customConfiguration.secondaryImageProperties.reservedLayoutSize.width
            imageView.preferredSymbolConfiguration = customConfiguration.secondaryImageProperties.preferredSymbolConfiguration
            
        }
        
    }
    
}


fileprivate class TestTableViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MKFormSecondaryImageCell()
        var content = cell.contentConfiguration(decorating: cell.defaultContentConfiguration())
        content.decoratee.text = "Hello"
        content.secondaryImage = .init(systemName: "circle.fill")
        content.secondaryImageProperties.tintColor = .red
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
