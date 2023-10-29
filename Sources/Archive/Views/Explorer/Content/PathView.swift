//
//  Copyright © Marc Rollin.
//

import DesignSystem
import SwiftUI

// MARK: - PathView

struct PathView: View {

    var body: some View {
        let path = explorer.path(from: explorer.currentNode)
        HStack {
            ForEach(path) { node in
                PathItemView(node: node, path: path)
            }
            Spacer()
        }
        .padding(.horizontal, designSystem.spacing)
        .padding(.vertical, designSystem.spacing(.semiSmall))
        .background(designSystem.color(.backgroundSubdued))
    }

    @Environment(Explorer.self) private var explorer
    @Environment(DesignSystem.self) private var designSystem
}
