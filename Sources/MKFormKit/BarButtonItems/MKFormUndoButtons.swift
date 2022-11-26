import UIKit
import Combine

extension UIViewController {
    
    public func addUndoButtons(undoManager: UndoManager) {
        var items = self.toolbarItems ?? []
        for item in items {
            if item is UIBarButtonItem.UndoButton {
                return
            }
        }
        let buttons = UIBarButtonItem.undoButtons(undoManager: undoManager)
        items.insert(buttons.undo, at: 0)
        items.insert(buttons.redo, at: 1)
        self.toolbarItems = items
    }
}

public extension UIBarButtonItem {
    
    static func undoButtons(undoManager: UndoManager?) -> (undo: UIBarButtonItem, redo: UIBarButtonItem) {
        func make(_ operation: UndoButton.UndoOperation, undoManager: UndoManager?) -> UndoButton {
            let button = UndoButton(barButtonSystemItem: operation == .undo ? .undo : .redo, target: nil, action: nil)
            button.operation = operation
            button.target = button
            button.action = #selector(button.pressed)
            button.undoManager = undoManager
            button.refresh()
            return button
        }
        return (make(.undo, undoManager: undoManager), make(.redo, undoManager: undoManager))
    }
    
    class UndoButton: UIBarButtonItem {
        
        private var cancellable: AnyCancellable?
        
        public enum UndoOperation {
            case redo
            case undo
        }
        
        public var operation: UndoOperation = .undo
        
        public weak var undoManager: UndoManager? {
            willSet {
                NotificationCenter.default.removeObserver(self)
            }
            didSet {
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(refresh),
                                                       name: .NSUndoManagerDidRedoChange,
                                                       object: undoManager)
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(refresh),
                                                       name: .NSUndoManagerDidUndoChange,
                                                       object: undoManager)
                NotificationCenter.default.addObserver(self, selector: #selector(refresh),
                                                       name: .NSUndoManagerDidCloseUndoGroup,
                                                       object: undoManager)
                refresh()
            }
        }
        
   
        @objc fileprivate func pressed() {
            switch operation {
            case .redo:
                undoManager?.redo()
            case .undo:
                undoManager?.undo()
            }
        }
        
        @objc fileprivate func refresh() {
            switch operation {
            case .redo:
                self.isEnabled = undoManager?.canRedo ?? false
            case .undo:
                self.isEnabled = undoManager?.canUndo ?? false
            }
        }
    }
    
    
    
}
