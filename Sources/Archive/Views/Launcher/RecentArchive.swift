//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import Dependencies
import Foundation
import SwiftData

@Model
final class RecentArchive {

    // MARK: Lifecycle

    init(url: URL, name: String, version: String, platforms: [ArchiveApp.Platform], icon: Data?, openedDate: Date = now) {
        self.url = url
        self.name = name
        self.version = version
        rawPlatforms = platforms.map(\.rawValue)
        self.icon = icon
        self.openedDate = openedDate
    }

    // MARK: Internal

    @Dependency(\.date.now) static var now

    @Attribute(.unique) let url: URL
    let name: String
    let version: String
    let rawPlatforms: [String]
    let icon: Data?
    let openedDate: Date

    var platforms: [ArchiveApp.Platform] {
        rawPlatforms.compactMap(ArchiveApp.Platform.init)
    }
}
