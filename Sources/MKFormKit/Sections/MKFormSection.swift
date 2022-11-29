import UIKit
import Combine

open class MKFormSection: NSObject, UpdatesConfigurationOnObjectWillChange {
    open var observedObject: AnyCancellable?
    open var header: UITableViewHeaderFooterView?
    open var cells: [UITableViewCell] = []
    open var footer: UITableViewHeaderFooterView?
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


