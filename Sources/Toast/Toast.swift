//
//  Copyright © Marc Rollin.
//

import Foundation

// MARK: - Toast

struct Toast: Identifiable {
    let id = UUID()
    let message: String
    let duration: Double
}
