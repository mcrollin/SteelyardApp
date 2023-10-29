//
//  Copyright © Marc Rollin.
//

import DesignComponents
import DesignSystem
import SwiftUI

struct ExplorerContent: View {

    // MARK: Internal

    var body: some View {
        VStack(spacing: .zero) {
            TreeMap(
                node: explorer.currentNode,
                hovering: explorer.hoveringNode,
                duplicates: explorer.archive.duplicateIDs
            ) { node in
                explorer.select(node: node)
            } onHover: { node, hovering in
                explorer.hover(node: node, hovering: hovering)
            }.layoutPriority(1)
            PathView()
        }
    }

    // MARK: Private

    @Environment(Explorer.self) private var explorer
    @Environment(DesignSystem.self) private var designSystem
}
