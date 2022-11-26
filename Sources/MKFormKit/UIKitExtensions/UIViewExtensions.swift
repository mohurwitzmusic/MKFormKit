import UIKit


enum MKLayoutAnchorEquality {
    case equalToConstant(CGFloat)
    case lessThanOrEqualToConstant(CGFloat)
    case greaterThanOrEqualToConstant(CGFloat)
    case equalTo(NSLayoutDimension)
    case lessThanOrEqualTo(NSLayoutDimension)
    case greaterThanOrEqualTo(NSLayoutDimension)
}


extension UIView {
    
    func constrainToEdges(_ edges: UIRectEdge, ofLayoutGuide layoutGuide: UILayoutGuide, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.right) {
            rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left).isActive = true
        }
    }
    
    func constrainToEdges(_ edges: UIRectEdge, of view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.right) {
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        }
    }
    
    @discardableResult
    func constrainToLayoutGuide(_ layoutGuide: UILayoutGuide, insets: UIEdgeInsets = .zero) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom)
        ])
        return self
    }
    
    @discardableResult
    func constrainToBounds(of view: UIView, insets: UIEdgeInsets = .zero) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
        return self
    }
    
    @discardableResult
    func constrainWidth(_ equality: MKLayoutAnchorEquality, priority: UILayoutPriority = .defaultHigh, multiplier: CGFloat = 1.0, constant: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch equality {
        case .equalToConstant(let cGFloat):
            constraint = self.widthAnchor.constraint(equalToConstant: cGFloat)
        case .lessThanOrEqualToConstant(let cGFloat):
            constraint = self.widthAnchor.constraint(lessThanOrEqualToConstant: cGFloat)
        case .greaterThanOrEqualToConstant(let cGFloat):
            constraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: cGFloat)
        case .equalTo(let nSLayoutDimension):
            constraint = self.widthAnchor.constraint(equalTo: nSLayoutDimension, multiplier: multiplier, constant: constant)
        case .lessThanOrEqualTo(let nSLayoutDimension):
            constraint = self.widthAnchor.constraint(equalTo: nSLayoutDimension, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqualTo(let nSLayoutDimension):
            constraint = self.widthAnchor.constraint(equalTo: nSLayoutDimension, multiplier: multiplier, constant: constant)
        }
        constraint.isActive = isActive
        constraint.priority = priority
        return constraint
    }
    
}
