//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import DesignSystem
import SwiftUI

struct ExplorerSidebarTreeView: View {

    // MARK: Internal

    let node: ArchiveNode

    var body: some View {
        ZStack {
            ScrollView {
                ExplorerSidebarTreeBranchView(node: node, level: 0)
                    .padding(designSystem.spacing)
            }
            .frame(minHeight: 20, maxHeight: .infinity)
            shortcuts
        }
        .onAppear {
            disclose(from: explorer.currentNode)
        }
        .onChange(of: explorer.currentNode) { _, _ in
            disclose(from: explorer.parent(for: explorer.currentNode))
        }
        .environment(finder)
    }

    // MARK: Private

    @Environment(DesignSystem.self) private var designSystem
    @Environment(Explorer.self) private var explorer

    @State private var finder = Finder()

    private var shortcuts: some View {
        ZStack {
            Button(String()) {
                let node = explorer.currentNode

                if finder.isDisclosed(node).wrappedValue,
                   let firstChild = node.childrenByCategory.first {
                    explorer.select(node: firstChild)
                } else {
                    var node = node
                    while let parent = explorer.parent(for: node) {
                        if let next = parent.childrenByCategory.element(after: node) {
                            explorer.select(node: next)
                            break
                        }
                        node = parent
                    }
                }
            }.keyboardShortcut(.downArrow, modifiers: [])

            Button(String()) {
                let node = explorer.currentNode

                guard let parent = explorer.parent(for: node) else { return }
                if parent.childrenByCategory.first == node {
                    explorer.select(node: parent)
                } else if var previous = parent.childrenByCategory.element(before: node) {
                    while finder.isDisclosed(previous).wrappedValue,
                          let last = previous.childrenByCategory.last {
                        previous = last
                    }
                    explorer.select(node: previous)
                }
            }.keyboardShortcut(.upArrow, modifiers: [])

            Button(String()) {
                if !finder.conceal(node: explorer.currentNode)
                    || !explorer.currentNode.shouldShowDetails,
                    let parent = explorer.parent(for: explorer.currentNode) {
                    explorer.select(node: parent)
                }
            }.keyboardShortcut(.leftArrow, modifiers: [])

            Button(String()) {
                if !finder.disclose(node: explorer.currentNode),
                   let firstChild = explorer.currentNode.childrenByCategory.first {
                    explorer.select(node: firstChild)
                }
            }.keyboardShortcut(.rightArrow, modifiers: [])
        }
        .opacity(designSystem.opacity(.clear))
    }

    private func disclose(from node: ArchiveNode?) {
        var node: ArchiveNode? = node
        while let next = node {
            finder.disclose(node: next)
            node = explorer.parent(for: next)
        }
    }

}
