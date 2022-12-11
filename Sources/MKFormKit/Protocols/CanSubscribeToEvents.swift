import UIKit
import Combine


/// A protocol describing an object that can subscribe to `Combine` published events by
/// storing its subscriptions in a set of `AnyCancellablw`

public protocol CanSubscribeToEvents : AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

public extension CanSubscribeToEvents where Self : UITableViewCell {
    
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
        object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }.store(in: &cancellables)
        return self
    }
    
    /// Supply a cell `configurationUpdateHandler` to be called on the event.  The view's `setNeedsUpdateConfiguration`
    /// will be called on each published change event.
    ///
    /// - Parameters:
    ///     - publisher: The publisher to receive events from.
    ///     - target: An object to pass into the `configurationUpdateHandler`.
    ///     - configurationUpdateHandler: a closure to be executed on each event. The closure captures a weak reference to the target.
    ///

    @discardableResult
    func onEvent<P: Publisher, T: AnyObject>(_ publisher: P, target: T, configurationUpdateHandler: @escaping ((T, Self, UICellConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak target] cell, state in
            guard let target else { return }
            configurationUpdateHandler(target, cell as! Self, state)
        }
        publisher.receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }.store(in: &cancellables)
        return self
    }

}

public extension CanSubscribeToEvents where Self : UITableViewHeaderFooterView {
    
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
        object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }.store(in: &cancellables)
        return self
    }
    
    /// Supply a cell `configurationUpdateHandler` to be called on the event.  The view's `setNeedsUpdateConfiguration`
    /// will be called on each published change event.
    ///
    /// - Parameters:
    ///     - publisher: The publisher to receive events from.
    ///     - target: An object to pass into the `configurationUpdateHandler`.
    ///     - configurationUpdateHandler: a closure to be executed on each event. The closure captures a weak reference to the target.
    ///

    @discardableResult
    func onEvent<P: Publisher, T: AnyObject>(_ publisher: P, target: T, configurationUpdateHandler: @escaping ((T, Self, UIViewConfigurationState) -> Void)) -> Self {
        self.configurationUpdateHandler = { [weak target] cell, state in
            guard let target else { return }
            configurationUpdateHandler(target, cell as! Self, state)
        }
        publisher.receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }.store(in: &cancellables)
        return self
    }

}


public extension CanSubscribeToEvents where Self : MKFormSection {
    
    /// Supply a cell `configurationUpdateHandler` to be called on `objectWillChange.
    ///
    /// - Parameters:
    ///     - object: The object to observe for changes. The object must conform to `ObservableObject`.

    @discardableResult
    func onObjectWillChange<T: ObservableObject>(_ object: T, applyImmediately: Bool = true, handler: @escaping ((T, Self) -> Void)) -> Self {
        object.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak object] _ in
                guard let self, let object else { return }
                handler(object, self)
            }.store(in: &cancellables)
        if applyImmediately {
            handler(object, self)
        }
        return self
    }
    
}

