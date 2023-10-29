//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignSystem
import SwiftUI

// MARK: - Inspector

struct ExplorerInspector: View {
    let node: ArchiveNode

    var body: some View {
        List {
            if let sections = node.metadata?.inspectorSections() {
                ForEach(sections) { section in
                    sectionGrid(section)
                }
            }
        }
        .listStyle(.sidebar)
    }

    private func sectionGrid(_ section: InspectorSection) -> some View {
        Section(section.title) {
            Grid(
                alignment: .topLeading,
                horizontalSpacing: designSystem.spacing(.small),
                verticalSpacing: designSystem.spacing(.small)
            ) {
                ForEach(section.items) { item in
//                    if section.items.first?.id != item.id {
//                        Divider().gridCellUnsizedAxes(.horizontal)
//                    }
                    GridRow(alignment: .firstTextBaseline) {
                        switch item {
                        case let .text(key, value):
                            Text(key)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text(value.description)
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
    }

    @Environment(DesignSystem.self) private var designSystem
}

struct InspectorSection: Identifiable {
    enum Item: Identifiable {
        case text(key: String, value: any CustomStringConvertible)

        var id: String {
            switch self {
            case let .text(key, _):
                key
            }
        }
    }

    let id = UUID()
    let title: String
    let items: [Item]
}

extension ArchiveNodeMetadata {

    fileprivate func inspectorSections() -> [InspectorSection] {
        switch self {
        case let .app(info),
            let .appex(info):
            [
                .init(title: "Info", items: [
                    .text(key: "marketing version", value: info.shortVersion),
                    .text(key: "build number", value: info.version),
                ])
            ]
        }
    }
}
