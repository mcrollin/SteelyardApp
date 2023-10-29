//
//  Copyright © Marc Rollin.
//

import ApplicationArchive
import Dependencies
import DesignComponents
import Foundation
import UniformTypeIdentifiers

// MARK: - Unarchiver

@MainActor
@Observable
public final class Unarchiver {

    // MARK: Lifecycle

    init() { }

    // MARK: Internal

    private(set) var archive: Archive?

    var isProcessing: Bool {
        processingTask != nil
            || archive != nil
            || processingTask?.isCancelled == true
    }

    func open(at url: URL) async {
        close()
        let processingTask = Task<Archive, Error> {
            try await Self.processArchive(at: url)
        }
        self.processingTask = processingTask

        do {
            archive = try await processingTask.value
        } catch {
            toaster.show(message: error.localizedDescription, level: .error)
        }
    }

    func close() {
        processingTask?.cancel()
        processingTask = nil
        archive = nil
    }

    // MARK: Private

    private enum UnarchivingError: LocalizedError {
        case invalidFileType(String)
        case unidentifiedFileType(URL)
        case cancelled

        var errorDescription: String? {
            switch self {
            case .invalidFileType(let type):
                "Cannot handle \(type) files.\nPlease ensure the file is either a .ipa or a .app format and try again."
            case .unidentifiedFileType(let url):
                "The file type for \(url.relativePath) could not be determined.\nPlease verify the file is either a .ipa or a .app format and try again."
            case .cancelled:
                "Cancelled"
            }
        }
    }

    @ObservationIgnored @Dependency(\.toaster) private var toaster
    @ObservationIgnored private var processingTask: Task<Archive, Error>?

    private static func processArchive(at url: URL) async throws -> Archive {
        guard let identifier = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier else {
            throw UnarchivingError.unidentifiedFileType(url)
        }

        let isCompressed: Bool = if UTType(identifier)?.conforms(to: .bundle) == true {
            false
        } else if UTType(identifier)?.conforms(to: .ipa) == true {
            true
        } else {
            throw UnarchivingError.invalidFileType(identifier)
        }

        let archive = try await Archive(from: url, isCompressed: isCompressed)

        guard !Task.isCancelled else {
            throw UnarchivingError.cancelled
        }

        return archive
    }
}
