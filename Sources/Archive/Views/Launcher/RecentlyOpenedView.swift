//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import DesignComponents
import DesignSystem
import SwiftData
import SwiftUI

// MARK: - RecentlyOpenedView

struct RecentlyOpenedView: View {

    // MARK: Internal

    var body: some View {
        if recentArchives.isEmpty {
            Text("No Recent Archives")
                .font(.body)
                .foregroundStyle(.secondary)
        } else {
            ZStack {
                List(recentArchives) { item in
                    ApplicationView(application: item) {
                        Task {
                            await unarchiver.open(at: item.url)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(designSystem.color(.accent))
                    )
                }.listStyle(.sidebar)
            }
        }
    }

    // MARK: Private

    @Query(sort: \RecentArchive.openedDate, order: .reverse) private var recentArchives: [RecentArchive]
    @Environment(Unarchiver.self) private var unarchiver
    @Environment(DesignSystem.self) private var designSystem
}

// MARK: - RecentArchive + ApplicationDisplayable

extension RecentArchive: ApplicationDisplayable { }
