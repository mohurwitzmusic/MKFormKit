import UIKit
import Combine


/// A protocol describing an object that updates its configuration by subscribing to an `ObservableObject`'s
/// `objectWillChange` publisher.
///
/// Used by  `MKFormCell` and `MKFormHeaderFooterView` to call
/// their `configurationUpdateHandler`.

public protocol UpdatesConfigurationOnObjectWillChange : AnyObject {
    var observedObject: AnyCancellable? { get set }
}

public extension UpdatesConfigurationOnObjectWillChange where Self : UITableViewCell {
    
    /// Supply a cell `configurationUpdateHandler` to be called on `objectWillChange`.  The cell's `setNeedsUpdateConfiguration`
    /// will be called on each published change event.
    ///
    /// - Parameters:
    ///     - object: The object to observe for changes. The object must conform to `ObservableObject`.
    ///     - configurationUpdateHandler: a closure to be executed on each `objectWillChange` notification. The closure captures a weak reference to the object.
    
    @discardableResult
    func onObjectWillChange<T: ObservableObject>(_ object: T, configurationUpdateHandler: @escaping ((T, Self, UICellConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak object] cell, state in
            guard let object else { return }
            configurationUpdateHandler(object, cell as! Self, state)
        }
        self.observedObject = object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }
        return self
    }
    

}

public extension UpdatesConfigurationOnObjectWillChange where Self : UITableViewHeaderFooterView {
    
    /// Supply a cell `configurationUpdateHandler` to be called on `objectWillChange`.  The view's `setNeedsUpdateConfiguration`
    /// will be called on each published change event.
    ///
    /// - Parameters:
    ///     - object: The object to observe for changes. The object must conform to `ObservableObject`.
    ///     - configurationUpdateHandler: a closure to be executed on each `objectWillChange` notification. The closure captures a weak reference to the object.

    @discardableResult
    func onObjectWillChange<T: ObservableObject>(_ object: T, configurationUpdateHandler: @escaping ((T, Self, UIViewConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak object] cell, state in
            guard let object else { return }
            configurationUpdateHandler(object, cell as! Self, state)
        }
        self.observedObject = object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }
        return self
    }
    

}


public extension UpdatesConfigurationOnObjectWillChange where Self : MKFormSection {
    
    /// Supply a cell `configurationUpdateHandler` to be called on `objectWillChange.
    ///
    /// - Parameters:
    ///     - object: The object to observe for changes. The object must conform to `ObservableObject`.

    @discardableResult
    func onObjectWillChange<T: ObservableObject>(_ object: T, applyImmediately: Bool = true, handler: @escaping ((T, Self) -> Void)) -> Self {
        self.observedObject = object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak object] _ in
                guard let self, let object else { return }
                handler(object, self)
            }
        if applyImmediately {
            handler(object, self)
        }
        return self
    }
    
}

