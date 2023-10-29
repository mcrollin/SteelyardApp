//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import SwiftData
import SwiftUI

// MARK: - UnarchiverContainer

@MainActor
private struct UnarchiverContainer<Content: View>: View {

    // MARK: Lifecycle

    init(content: Content) {
        self.content = content
    }

    // MARK: Internal

    let content: Content

    var body: some View {
        content
            .environment(Unarchiver())
            .modelContainer(modelContainer)
            .onChange(of: unarchiver.archive) { _, archive in
                guard let archive, let app = archive.apps.first else { return }
                modelContainer.mainContext.insert(
                    RecentArchive(
                        url: archive.url,
                        name: app.name,
                        version: app.version,
                        platforms: archive.apps.flatMap(\.platforms),
                        icon: app.icon
                    )
                )
            }
    }

    // MARK: Private

    private let modelContainer = try! ModelContainer(for: RecentArchive.self)
    private let unarchiver = Unarchiver()
}

@MainActor
extension View {

    func withUnarchiver() -> some View {
        UnarchiverContainer(content: self)
    }
}
