//
//  Copyright © Marc Rollin.
//

import DesignSystem
import SwiftUI

// MARK: - DesignSystemContainer

private struct DesignSystemContainer<Content: View>: View {
    let content: Content

    var body: some View {
        content
            .environment(designSystem)
            .onAppear {
                designSystem.dynamicTypeSize = dynamicTypeSize
            }
            .onChange(of: dynamicTypeSize) { _, newValue in
                designSystem.dynamicTypeSize = newValue
            }
    }

    private let designSystem = DesignSystem()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
}

extension View {

    public func withDesignSystem() -> some View {
        DesignSystemContainer(content: self)
    }
}
