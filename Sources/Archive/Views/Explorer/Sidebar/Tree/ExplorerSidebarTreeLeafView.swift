//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import DesignSystem
import SwiftUI

// MARK: - ExplorerSidebarTreeItemView

struct ExplorerSidebarTreeLeafView: View {

    // MARK: Internal

    let node: ArchiveNode
    let level: Int

    var body: some View {
        let foreground = foregroundColor(node: node)
        let background = backgroundColor(node: node)

        return HStack(spacing: 0) {
            DiscloseButton(isExpanded: finder.isDisclosed(node))
                .foregroundColor(foreground ?? .secondary)
                .opacity(designSystem.opacity(node.children.isEmpty ? .clear : .opaque))

            node.icon
                .foregroundColor(foreground ?? node.color ?? .secondary)
                .frame(width: 14, height: 14, alignment: .center)
                .padding(.trailing, designSystem.spacing(.extraSmall))

            Text(node.name)
                .font(.system(.body))
                .foregroundColor(foreground ?? .primary)
                .lineLimit(1)
                .padding(.trailing, designSystem.spacing(.extraSmall))

            Spacer()

            Text(node.sizeInBytes.formattedBytes())
                .font(.system(.caption).weight(.bold).monospacedDigit())
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(designSystem.color(.background).opacity(designSystem.opacity(.medium)))
                        .stroke(.secondary.opacity(designSystem.opacity(.faint)), lineWidth: 1)
                )
                .layoutPriority(1)
        }
        .padding(.vertical, designSystem.spacing(.extraExtraSmall) + 1)
        .padding(.leading, designSystem.spacing(.extraExtraSmall) + (designSystem.spacing * CGFloat(level)))
        .padding(.trailing, designSystem.spacing(.small))
        .background {
            RoundedRectangle(cornerRadius: 6, style: .circular)
                .fill(background)
        }
        .id(node.id)
        .onHover { hovering in
            explorer.hover(node: node, hovering: hovering)
        }
        .onTapGesture {
            select(node: node)
        }
    }

    // MARK: Private

    @Environment(Finder.self) private var finder
    @Environment(Explorer.self) private var explorer
    @Environment(DesignSystem.self) private var designSystem

    private func select(node: ArchiveNode, animated: Bool = true) {
        if explorer.currentNode == node {
            finder.toggle(node: node, animated: animated)
        } else {
            explorer.select(node: node, animated: animated)
        }
    }

    private func foregroundColor(node: ArchiveNode) -> Color? {
        if explorer.hasDuplicates(node: node) {
            designSystem.color(.negative)
        } else if explorer.currentNode == node {
            designSystem.color(.highlight)
        } else {
            nil
        }
    }

    private func backgroundColor(node: ArchiveNode) -> Color {
        if explorer.currentNode == node {
            if explorer.hasDuplicates(node: node) {
                designSystem.color(.negative).opacity(designSystem.opacity(.faint))
            } else {
                designSystem.color(.highlight).opacity(designSystem.opacity(.faint))
            }
        } else if explorer.hoveringNode == node {
            designSystem.color(.highlight).opacity(designSystem.opacity(.hint))
        } else {
            .black.opacity(designSystem.opacity(.veil))
        }
    }
}
