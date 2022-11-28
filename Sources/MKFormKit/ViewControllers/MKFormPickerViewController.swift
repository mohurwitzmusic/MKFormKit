import UIKit

public class MKFormPickerViewController<T: Equatable>: UITableViewController {
    
    public init(style: UITableView.Style = .plain, title: String = "", items: [T], selected: T, cellConfiguration: @escaping ((T) -> UIListContentConfiguration)) {
        guard items.count > 0 else {
            fatalError("The items can't be empty")
        }
        guard items.contains(selected) else {
            fatalError("The selected item was not one of the available items")
        }
        self.items = items
        self.selectedItem = selected
        self.cellConfiguration = cellConfiguration
        super.init(style: style)
        self.title = title
    }


    private var _undoManager: UndoManager?
    
    public override var undoManager: UndoManager? {
        _undoManager
    }
    
    
    private var items: [T] = []
    private var selectedItem: T!
    private var cellConfiguration: ((T) -> UIListContentConfiguration) = { _ in return .cell() }
    private var selectionHandler: ((T) -> Void)?
    public var willDisappearHandler: ((T) -> Void)?
    
  
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.contentConfiguration = cellConfiguration(items[indexPath.row])
        cell.accessoryType = items[indexPath.row] == selectedItem ? .checkmark : .none
        return cell
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = items.firstIndex(of: selectedItem) {
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willDisappearHandler?(selectedItem)
    }
    
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let oldValue = selectedItem
        let newValue = items[indexPath.row]
        if oldValue == newValue { return }
        performUndoableAction { [weak self] in
            self?.selectItem(newValue)
        } undoAction: { [weak self] in
            if let oldValue {
                self?.selectItem(oldValue)
            }
        }
    }
    
    private func performUndoableAction(_ doAction: @escaping (() -> Void), undoAction: @escaping (() -> Void)) {
        undoManager?.registerUndo(withTarget: self) {
            $0.performUndoableAction(undoAction, undoAction: doAction)
        }
        doAction()
    }
    
    private func selectItem(_ item: T) {
        selectedItem = item
        tableView.reloadData()
        selectionHandler?(item)
    }
}



public extension MKFormPickerViewController {
    
    @discardableResult
    func onSelection(_ handler: @escaping ((T) -> Void)) -> Self {
        self.selectionHandler = handler
        return self
    }
    
    @discardableResult
    func onSelection<Target: AnyObject>(target: Target, _ handler: @escaping ((Target, T) -> Void)) -> Self {
        self.selectionHandler = { [weak target] selection in
            guard let target else { return }
            handler(target, selection)
        }
        return self
    }
    
    @discardableResult
    func onWillDisappear(_ handler: @escaping ((T) -> Void)) -> Self {
        self.willDisappearHandler = handler
        return self
    }
    
    @discardableResult
    func onWillDisappear<Target: AnyObject>(target: Target, _ handler: @escaping ((Target, T) -> Void)) -> Self {
        self.willDisappearHandler = { [weak target] selection in
            guard let target else { return }
            handler(target, selection)
        }
        return self
    }
    
    @discardableResult
    func enableUndo(_ enabled: Bool) -> Self {
        if enabled {
            _undoManager = .init()
            let undoButtons = UIBarButtonItem.undoButtons(undoManager: undoManager!)
            self.toolbarItems = [undoButtons.undo, undoButtons.redo]
        } else {
            _undoManager = nil
            toolbarItems = []
        }
        return self
    }

    func show(in viewController: UIViewController, sender: Any? = nil) {
        viewController.show(self, sender: sender)
    }
    
    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
}

public extension MKFormPickerViewController where T : BinaryInteger, T : Strideable, T.Stride == Int {
    
    static func numberPicker(title: String = "", style: UITableView.Style = .plain, _ range: ClosedRange<T>, selected: T) -> MKFormPickerViewController<T> {
        let items = Array<T>(range.map { $0 } )
        return .init(style: style, title: title, items: items, selected: selected) { i in
                .cell().withText("\(i)")
        }
    }


    
}
