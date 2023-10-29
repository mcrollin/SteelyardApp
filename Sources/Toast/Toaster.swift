//
//  Copyright © Marc Rollin.
//

import SwiftUI

// MARK: - Toaster

@Observable
final class Toaster {
    private(set) var toasts = [Toast]()

    func show(message: String, duration: Double) {
        let toast = Toast(message: message, duration: duration)
        withAnimation {
            toasts.append(toast)
        }
        Task {
            try await Task.sleep(for: .seconds(toast.duration))
            remove(toast: toast)
        }
    }

    func remove(toast: Toast) {
        withAnimation {
            toasts.removeAll { $0.id == toast.id }
        }
    }
}
