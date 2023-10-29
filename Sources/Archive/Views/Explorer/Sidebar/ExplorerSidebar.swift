//
//  Copyright © Marc Rollin.
//

import SwiftUI

struct ExplorerSidebar: View {

    // MARK: Internal

    var body: some View {
        VStack(spacing: .zero) {
            ExplorerSidebarTreeView(node: explorer.archive.root)
            ExplorerSidebarApplicationsView()
        }
    }

    // MARK: Private

    @Environment(Explorer.self) private var explorer
}
