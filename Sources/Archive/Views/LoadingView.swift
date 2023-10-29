//
//  Copyright © Marc Rollin.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        unarchiver.close()
                    } label: {
                        Label("Close archive", systemImage: "xmark.circle")
                    }
                }
            }
    }

    @Environment(Unarchiver.self) private var unarchiver
}
