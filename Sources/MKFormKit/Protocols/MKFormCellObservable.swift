import Combine

public protocol MKFormCellObservable: AnyObject {
    var cancellable: AnyCancellable? { get set }
}

public extension MKFormCellObservable {
    
    @discardableResult
    func onObjectWillChange<T: ObservableObject>(_ object: T, handler: @escaping ((T, Self) -> Void)) -> Self {
        cancellable = object.objectWillChange.sink { [weak self, weak object] _ in
            guard let self, let object else { return }
            handler(object, self)
        }
        return self
    }
    
}
