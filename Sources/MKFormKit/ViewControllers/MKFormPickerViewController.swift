import UIKit

public class MKFormPickerViewController<T: Equatable>: UITableViewController {
    
    public init(style: UITableView.Style = .insetGrouped, items: [T], selected: T, cellConfiguration: @escaping ((T) -> UIListContentConfiguration), onSelection: @escaping (T) -> Void) {
        guard items.contains(selected) else {
            fatalError()
        }
        self.items = items
        self.selectedItem = selected
        self.cellConfiguration = cellConfiguration
        self.onSelection = onSelection
        super.init(style: style)
    }
    
    public enum SelectionTrigger {
        case continuously
        case onDisappear
    }
    
    private var _undoManager: UndoManager?
    
    public override var undoManager: UndoManager? {
        _undoManager
    }
    
    
    private var items: [T] = []
    private var selectedItem: T!
    private var cellConfiguration: ((T) -> UIListContentConfiguration) = { _ in return .cell() }
    private var onSelection: ((T) -> Void)?
    public var selectionTrigger = SelectionTrigger.continuously
    public var onWillDissapear: ((T) -> Void)?
    
    public func enableUndoRegistration(_ enabled: Bool) {
        if enabled {
            _undoManager = .init()
            addUndoButtons(undoManager: undoManager!)
        } else {
            _undoManager = nil
            toolbarItems = []
        }
    }
    
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
        onWillDissapear?(selectedItem)
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
        if selectionTrigger == .continuously {
            onSelection?(item)
        }
    }
}



public extension MKFormPickerViewController {
    
    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    func show(in viewController: UIViewController) {
        viewController.show(self, sender: nil)
    }
}

public extension MKFormPickerViewController where T : BinaryInteger, T : Strideable, T.Stride == Int {
    
    static func numberPicker(style: UITableView.Style = .insetGrouped, _ range: ClosedRange<T>, selected: T, onSelection: @escaping ((T) -> Void)) -> MKFormPickerViewController<T> {
        let items = Array<T>(range.map { $0 } )
        return .init(style: style, items: items, selected: selected) { i in
                .cell().withText("\(i)")
        } onSelection: { i in
            onSelection(i)
        }
    }


    
}
