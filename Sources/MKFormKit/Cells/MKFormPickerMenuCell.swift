import UIKit


open class MKFormPickerMenuCell: MKFormCell {

    public let button = UIButton(configuration: .plain())

    public struct CellConfiguration {
        public var title: String
        public var isSelected = false
        public init(title: String, isSelected: Bool = false) {
            self.title = title
            self.isSelected = isSelected
        }
    }
    
    @discardableResult
    public func configureMenu<T: Equatable>(items: [T], configuration: ((T) -> CellConfiguration), onSelection: @escaping ((T) -> Void)) -> Self {
        let configurations = items.map { configuration($0) }.first(where: { $0.isSelected } )
        button.configuration?.title = configurations?.title
        let actions: [UIAction] = items.map { item in
            let config = configuration(item)
            let checkmark = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.blue)
            return UIAction(title: config.title, image: config.isSelected ? checkmark : nil) { [weak self] _ in
                self?.button.configuration?.title = config.title
                onSelection(item)
            }
        }
        self.button.menu = UIMenu(children: actions)
        return self
    }

    public override func setup() {
        selectionStyle = .none
        hitTestingView = button
        configureButton()
    }

    private func configureButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            button.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        button.configuration = .plain()
        button.configuration?.imagePlacement = .trailing
        button.configuration?.imagePadding = 5
        button.configuration?.image = .init(systemName: "chevron.up.chevron.down")
        button.showsMenuAsPrimaryAction = true
    }

}

