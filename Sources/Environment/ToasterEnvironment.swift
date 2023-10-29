//
//  Copyright © Marc Rollin.
//

import SwiftUI

// MARK: - ToastContainer

private struct ToastContainer<Content: View>: View {
    let content: Content

    var body: some View {
        content
            .overlay(ToastOverlay())
            .environment(toaster)
    }

    private let toaster = Toaster()
}

extension View {

    func withToaster() -> some View {
        ToastContainer(content: self)
    }
}
