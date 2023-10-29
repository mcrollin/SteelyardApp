//
//  Copyright © Marc Rollin.
//

import DesignComponents
import SwiftUI

// MARK: - SteelyardApp

@main
struct SteelyardApp: App {

    // MARK: Internal

    var body: some Scene {
        WindowGroup {
            ArchiveView()
                .withUnarchiver()
                .withToaster()
                .withDesignSystem()
        }
        .commands {
            appMenu
        }
    }

    // MARK: Private

    private var appMenu: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("menu.new-window") {
//                openWindow(id: "main")
            }
            .keyboardShortcut("n", modifiers: .shift)
        }
//        CommandGroup(replacing: .textFormatting) {
//            Menu("menu.font") {
//                Button("menu.font.bigger") {
//                    if theme.fontSizeScale < 1.5 {
//                        theme.fontSizeScale += 0.1
//                    }
//                }
//                Button("menu.font.smaller") {
//                    if theme.fontSizeScale > 0.5 {
//                        theme.fontSizeScale -= 0.1
//                    }
//                }
//            }
//        }
    }
}
