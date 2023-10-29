//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import DesignSystem
import SwiftUI

// MARK: - ArchiveView

@MainActor
struct ArchiveView: View {

    // MARK: Internal

    var body: some View {
        content
            .background(designSystem.color(.background))
    }

    @ViewBuilder
    var content: some View {
        if let archive = unarchiver.archive {
            ExplorerNavigation(archive: archive)
        } else if unarchiver.isProcessing {
            LoadingView()
        } else {
            LauncherView()
        }
    }

    // MARK: Private

    @Environment(DesignSystem.self) private var designSystem
    @Environment(Unarchiver.self) private var unarchiver
}
