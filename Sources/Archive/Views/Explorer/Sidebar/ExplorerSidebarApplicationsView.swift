//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import DesignSystem
import SwiftUI

// MARK: - ExplorerSidebarApplicationsView

struct ExplorerSidebarApplicationsView: View {

    // MARK: Internal

    var body: some View {
        ExpandableGroup(isExpanded: $isExpanded) {
            VStack(spacing: designSystem.spacing) {
                ForEach(explorer.archive.apps) { app in
                    ApplicationView(application: app) {
                        explorer.select(node: app.node)
                    }
                }
            }
            .padding(.top, designSystem.spacing)
            .padding(.bottom, designSystem.spacing(.small))
        } label: {
            HStack {
                Text("Applications")
                    .font(.headline)
                Spacer()
                if isHovering {
                    DiscloseButton(
                        isExpanded: $isExpanded,
                        size: 10,
                        padding: .extraExtraSmall
                    )
                }
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onHover { hovering in
                isHovering = hovering
            }
        }
        .padding(.horizontal, designSystem.spacing)
        .padding(.vertical, designSystem.spacing(.semiSmall))
        .background(designSystem.color(.backgroundSubdued))
    }

    // MARK: Private

    @State private var isHovering = false
    @State private var isExpanded = true
    @Environment(Explorer.self) private var explorer
    @Environment(DesignSystem.self) private var designSystem
}

// MARK: - ArchiveApp + ApplicationDisplayable

extension ArchiveApp: ApplicationDisplayable { }
