//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import SwiftUI

// MARK: - ExplorerSidebarTreeBranchView

struct ExplorerSidebarTreeBranchView: View {

    // MARK: Internal

    let node: ArchiveNode
    let level: Int

    var body: some View {
        if node.children.isEmpty {
            ExplorerSidebarTreeLeafView(node: node, level: level)
        } else {
            ExpandableGroup(isExpanded: finder.isDisclosed(node)) {
                ForEach(node.childrenByCategory) { child in
                    ExplorerSidebarTreeBranchView(node: child, level: level + 1)
                }
            } label: {
                ExplorerSidebarTreeLeafView(node: node, level: level)
            }
        }
    }

    // MARK: Private

    @Environment(Finder.self) private var finder
}
