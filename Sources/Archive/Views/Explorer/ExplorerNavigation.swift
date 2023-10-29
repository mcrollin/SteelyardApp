//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignSystem
import SwiftUI

// MARK: - ArchiveExplorerView

@MainActor
struct ExplorerNavigation: View {

    // MARK: Lifecycle

    init(archive: Archive) {
        _explorer = .init(initialValue: Explorer(archive: archive))
    }

    // MARK: Internal

    var body: some View {
        NavigationSplitView {
            ExplorerSidebar()
                .navigationSplitViewColumnWidth(min: 320, ideal: 400, max: 500)
        } detail: {
            ExplorerContent()
                .background(designSystem.color(.background))
                .navigationSplitViewColumnWidth(min: 400, ideal: 800)
                .inspector(isPresented: $showInspector) {
                    ExplorerInspector(node: explorer.currentNode)
                        .inspectorColumnWidth(min: 300, ideal: 360, max: 400)
                }
        }
        .navigationTitle(explorer.currentNode.name)
        .navigationSubtitle(explorer.currentNode.sizeInBytes.formattedBytes())
        .toolbar {
            toolbarContent
        }
        .environment(explorer)
    }

    // MARK: Private

    @Environment(Unarchiver.self) private var unarchiver
    @Environment(DesignSystem.self) private var designSystem
    @State private var explorer: Explorer
    @State private var showInspector = true

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if let parent = explorer.parent(for: explorer.currentNode) {
            ToolbarItem(placement: .navigation) {
                Button {
                    explorer.select(node: parent)
                } label: {
                    Label("Navigate to parent item", systemImage: "arrow.backward")
                }
            }
        }

        ToolbarItem(placement: .navigation) {
            explorer.currentNode.icon
                .foregroundStyle(explorer.currentNode.color ?? .secondary)
                .frame(width: 20, height: 20, alignment: .center)
        }

        ToolbarItem(placement: .cancellationAction) {
            Button {
                unarchiver.close()
            } label: {
                Label("Close archive", systemImage: "xmark.circle")
            }
        }

        ToolbarItem(placement: .confirmationAction) {
            Button {
                showInspector.toggle()
            } label: {
                Label("Toggle Inspector", systemImage: "sidebar.trailing")
            }
        }
    }
}
