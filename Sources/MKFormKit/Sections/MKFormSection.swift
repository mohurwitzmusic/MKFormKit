import UIKit
import Combine

open class MKFormSection: NSObject, CanSubscribeToEvents {
    open var cancellables = Set<AnyCancellable>()
    open var header: UITableViewHeaderFooterView?
    open var cells: [UITableViewCell] = []
    open var footer: UITableViewHeaderFooterView?
    open func prepareForSnapshot() { }
}

extension NSDiffableDataSourceSnapshot
where SectionIdentifierType == MKFormSection,
      ItemIdentifierType == UITableViewCell {
    public init(sections: [MKFormSection]) {
        self.init()
        for section in sections {
            self.appendSections([section])
            self.appendItems(section.cells, toSection: section)
        }
    }
}


