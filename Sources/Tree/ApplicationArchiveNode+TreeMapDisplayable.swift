//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import Foundation
import SwiftUI

extension ApplicationArchive.App.Platform {

    var icon: some View {
        let systemName = switch self {
        case .iphone: "iphone"
        case .mac: "macbook"
        case .ipad: "ipad"
        case .tv: "appletv"
        case .watch: "applewatch"
        }

        return Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

// MARK: - ApplicationArchive.Node + TreeMapDisplayable

extension ApplicationArchive.Node: TreeMapDisplayable {

    // MARK: Public

    public var description: String {
        name
    }

    public var color: Color? {
        if isDuplicate {
            .red
        } else {
            switch category {
            case .app: .teal
            case .appExtension: .brown
            case .assetCatalog: .green
            case .binary: .blue
            case .bundle: .indigo
            case .content: .mint
            case .data: .gray
            case .font: .cyan
            case .framework: .brown
            case .localization: .orange
            case .model: .purple
            case .folder: nil
            }
        }
    }

    public var shouldShowDetails: Bool {
        !childrenBySize.isEmpty
    }

    public var size: CGFloat {
        CGFloat(sizeInBytes)
    }

    public var segments: [ApplicationArchive.Node] {
        childrenBySize
    }

    // MARK: Internal

    var icon: some View {
        let systemName = switch category {
        case .app: "folder.fill.badge.gearshape"
        case .appExtension: "puzzlepiece.extension.fill"
        case .assetCatalog: "photo.on.rectangle.fill"
        case .binary: "apple.terminal.fill"
        case .bundle: "shippingbox.fill"
        case .content: "doc.text.fill"
        case .data: "doc.badge.gearshape.fill"
        case .font: "textformat"
        case .framework: "shippingbox.fill"
        case .localization: "character.bubble.fill"
        case .model: "doc.badge.gearshape.fill"
        case .folder: "folder.fill"
        }

        return Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
