//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignSystem
import SwiftUI

// MARK: - PathItemView

struct PathItemView: View {

    // MARK: Internal

    let node: ArchiveNode
    let path: [ArchiveNode]

    var body: some View {
        HStack {
            disclosure
            Text(node.name)
                .fontWeight(.semibold)
                .foregroundStyle(foregroundStyle)
                .frame(minWidth: 20)
        }
        .layoutPriority(layoutPriority)
        .onHover { hovering in
            explorer.hover(node: node, hovering: hovering)
        }
        .onTapGesture {
            explorer.select(node: node)
        }
    }

    // MARK: Private

    @Environment(Explorer.self) private var explorer
    @Environment(DesignSystem.self) private var designSystem

    @ViewBuilder
    private var disclosure: some View {
        if node != path.first {
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 8, alignment: .center)
                .foregroundColor(.secondary)
                .layoutPriority(0.75)
        } else {
            EmptyView()
        }
    }

    private var foregroundStyle: Color {
        if node == explorer.hoveringNode {
            designSystem.color(.highlight)
        } else {
            .primary
        }
    }

    private var layoutPriority: Double {
        if node == explorer.hoveringNode {
            1.0
        } else if node == path.last {
            0.5
        } else if node == path.first {
            0.25
        } else {
            0.1
        }
    }
}
