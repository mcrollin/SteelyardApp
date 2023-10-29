//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import Dependencies
import DesignSystem
import SwiftUI

// MARK: - Explorer

@Observable
final class Explorer {

    // MARK: Lifecycle

    init(archive: Archive) {
        self.archive = archive
        currentNode = archive.apps.first?.node ?? archive.root
        duplicates = archive.duplicateIDs
    }

    // MARK: Public

    public func path(from node: ArchiveNode) -> [ArchiveNode] {
        var path = [node]
        var node = node
        while let parent = archive.parents[node.id] {
            path.insert(parent, at: 0)
            node = parent
        }
        return path
    }

    // MARK: Internal

    let archive: Archive
    private(set) var currentNode: ArchiveNode
    private(set) var hoveringNode: ArchiveNode?
    private let duplicates: Set<ArchiveNode.ID>

//    @ObservationIgnored @AppStorage("show_duplicates") private var __isShowingDuplicates = true
//    var isShowingDuplicates: Bool {
//        get {
//            access(keyPath: \.isShowingDuplicates)
//            return __isShowingDuplicates
//        } set {
//            withMutation(keyPath: \.isShowingDuplicates) {
//                __isShowingDuplicates = newValue
//            }
//        }
//    }

    func select(node: ArchiveNode, animated: Bool = true) {
        withAnimation(animated ? designSystem.animation(.select) : .none) {
            currentNode = node
        }
    }

    func hover(node: ArchiveNode, hovering: Bool, animated: Bool = true) {
        withAnimation(animated ? designSystem.animation(.highlight) : .none) {
            hoveringStack.removeAll { $0 == node }

            if hovering {
                hoveringStack.append(node)
            }

            hoveringNode = hoveringStack.last
        }
    }

    func parent(for node: ArchiveNode) -> ArchiveNode? {
        archive.parents[node.id]
    }

    func hasDuplicates(node: ArchiveNode) -> Bool {
        duplicates.contains(node.id)
    }

    // MARK: Private

    private var hoveringStack = [ArchiveNode]()
    @ObservationIgnored @Dependency(\.designSystem) private var designSystem
}
