//
//  Copyright © Marc Rollin.
//

import DesignSystem
import SwiftUI

// MARK: - ToastView

struct ToastView: View {

    let toast: Toast

    var body: some View {
        Text(toast.message)
            .padding()
            .background(designSystem.color(.background).opacity(designSystem.opacity(.medium)))
            .foregroundColor(.white)
            .cornerRadius(8)
            .onTapGesture {
                toaster.remove(toast: toast)
            }
    }

    @Environment(Toaster.self) private var toaster
    @Environment(DesignSystem.self) private var designSystem
}

