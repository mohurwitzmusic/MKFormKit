import UIKit

public struct MKPickerForm<T: Hashable>: Hashable {
    
    public struct ListItem: Hashable, Equatable {
    
        public let item: T
        public var content: UIListContentConfiguration = .cell()
        
        public static func ==(lhs: ListItem, rhs: ListItem) -> Bool {
            return lhs.item == rhs.item
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(item)
        }
        
        public init(item: T, text: String, image: UIImage? = nil) {
            self.item = item
            self.content.text = text
            self.content.image = image
        }
    }
    
    public init(title: String = "",
                listItems: [MKPickerForm<T>.ListItem] = [],
                selections: Set<T> = [],
                numberOfSelectionsAllowed: ClosedRange<Int> = 1...1) {
        self.title = title
        self.listItems = listItems
        self.selections = selections
        self.numberOfSelectionsAllowed = numberOfSelectionsAllowed
        assertInvariants()
    }
    
    
    public var title: String
    public private(set) var listItems: [ListItem]
    public private(set) var selections: Set<T>
    public private(set) var numberOfSelectionsAllowed: ClosedRange<Int>

    public mutating func configure(items: [ListItem],
                                   selections: Set<T>,
                                   numberOfSelectionsAllowed: ClosedRange<Int>) {
        self.listItems = items
        self.selections = selections
        self.numberOfSelectionsAllowed = numberOfSelectionsAllowed
        assertInvariants()
    }
    
    public mutating func selectItem(_ item: T) {
        if numberOfSelectionsAllowed == 1...1 {
            toggleItem(item)
        } else {
            addOrRemoveItem(item)
        }
        assertInvariants()
    }
    
    private mutating func toggleItem(_ item: T) {
        selections = [item]
    }
    
    private mutating func addOrRemoveItem(_ item: T) {
        if selections.contains(item) && selections.count > numberOfSelectionsAllowed.lowerBound {
            selections.remove(item)
        } else if selections.count < numberOfSelectionsAllowed.upperBound {
            selections.insert(item)
        }
    }
    
    private func assertInvariants() {
        if !selections.isEmpty {
            assert(selections.allSatisfy { listItems.map { $0.item }.contains($0) }, "Selected items must be one of the available items in the list. provided: \(selections)")
        }
        assert(numberOfSelectionsAllowed.contains(selections.count), "List requires a minimum of \(numberOfSelectionsAllowed.lowerBound) and a maximum of \(numberOfSelectionsAllowed.upperBound) selections. provided: \(selections)")
        assert(numberOfSelectionsAllowed.lowerBound >= 0, "Number of selections must be a positive number. provided: \(numberOfSelectionsAllowed)")
    }

}


public extension MKPickerForm {
    
    static func numberPicker(title: String, range: ClosedRange<Int>, selection: Int) -> MKPickerForm<Int> {
        let listItems: [MKPickerForm<Int>.ListItem] = range.map { .init(item: $0, text: "\($0)", image: nil) }
        return .init(title: title, listItems: listItems, selections: [selection], numberOfSelectionsAllowed: 1...1)
    }
    
    static func midiDataBytePicker(title: String, selection: UInt8) -> MKPickerForm<UInt8> {
        let listItems: [MKPickerForm<UInt8>.ListItem] = (0..<128).map { .init(item: $0, text: "\($0)") }
        return .init(title: title, listItems: listItems, selections: [selection], numberOfSelectionsAllowed: 1...1)
    }
    
}
