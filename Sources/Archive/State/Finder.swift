//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import Dependencies
import DesignSystem
import SwiftUI

// MARK: - Finder

@Observable
final class Finder {

    // MARK: Internal

    func isDisclosed(_ node: ArchiveNode) -> Binding<Bool> {
        Binding(
            get: {
                self.expandedNodes.contains(node.id)
            },
            set: { newValue in
                if newValue {
                    self.expandedNodes.insert(node.id)
                } else {
                    self.expandedNodes.remove(node.id)
                }
            }
        )
    }

    @discardableResult
    func disclose(node: ArchiveNode, animated: Bool = true) -> Bool {
        withAnimation(animated ? designSystem.animation(.disclose) : .none) {
            expandedNodes.insert(node.id).inserted
        }
    }

    @discardableResult
    func conceal(node: ArchiveNode, animated: Bool = true) -> Bool {
        withAnimation(animated ? designSystem.animation(.disclose) : .none) {
            expandedNodes.remove(node.id) != nil
        }
    }

    func toggle(node: ArchiveNode, animated: Bool = true) {
        if expandedNodes.contains(node.id) {
            conceal(node: node, animated: animated)
        } else {
            disclose(node: node, animated: animated)
        }
    }

    // MARK: Private

    private var expandedNodes: Set<ArchiveNode.ID> = []
    @ObservationIgnored @Dependency(\.designSystem) private var designSystem
}
