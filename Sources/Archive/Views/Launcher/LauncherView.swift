//
//  Copyright © Marc Rollin.
//

import DesignComponents
import DesignSystem
import Platform
import SwiftUI
import UniformTypeIdentifiers

// MARK: - LauncherView

struct LauncherView: View {

    // MARK: Internal

    var body: some View {
        content
            .padding(.vertical, designSystem.spacing(.large))
            .padding(.horizontal, designSystem.spacing(.extraExtraLarge))
            .inspector(isPresented: $showInspector) {
                RecentlyOpenedView()
                    .inspectorColumnWidth(
                        min: 300, ideal: 360, max: 400
                    )
            }
//            .blur(radius: isDragging ? 10 : 0)
            .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers, _ in
                handleDrop(providers: providers)
                return true
            }
            .overlay {
                if isDragging {
                    Image(systemName: "arrow.down.circle.dotted")
                        .symbolEffect(.bounce.up.byLayer, options: .repeating.speed(0.8), value: dropAnimationRunning)
                        .font(.system(size: 50))
                        .onAppear {
                            dropAnimationRunning = true
                        }
                        .onDisappear {
                            dropAnimationRunning = false
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showInspector.toggle()
                    } label: {
                        Label("Toggle Inspector", systemImage: "sidebar.trailing")
                    }
                }
            }
    }

    @ViewBuilder
    var content: some View {
        VStack(spacing: designSystem.spacing) {
            VStack(spacing: designSystem.spacing(.small)) {
                Image(nsImage: NSImage(resource: .init(name: "AppIcon", bundle: .main)))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .border(.primary)
                Text("Steelyard")
                    .font(.system(size: 40, weight: .black))

                if let marketingVersion = Bundle.marketingVersion,
                   let buildNumber = Bundle.buildNumber {
                    Text("Version \(marketingVersion) (\(buildNumber))")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, designSystem.spacing)

            Button {
                openFilePicker()
            } label: {
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.secondary)
                    Text("Open File...")
                }
            }
            .buttonStyle(.secondary)

            Text("Drag an IPA file here or click the button to select one")
        }
    }

    // MARK: Private

    @Environment(Unarchiver.self) private var unarchiver

    @State private var dropAnimationRunning = false
    @State private var isDragging = false
    @State private var showInspector = true

    @Environment(DesignSystem.self) private var designSystem

    private func handleDrop(providers: [NSItemProvider]) {
        guard let itemProvider = providers.first(where: { $0.canLoadObject(ofClass: URL.self) }) else { return }

        _ = itemProvider.loadDataRepresentation(for: UTType.fileURL) { [unarchiver] data, _ in
            Task {
                guard let data, let url = URL(dataRepresentation: data, relativeTo: nil) else {
                    return
                }

                await unarchiver.open(at: url)
            }
        }
    }

    private func openFilePicker() {
        Task { @MainActor [unarchiver] in
            let panel = NSOpenPanel()..{
                $0.allowedContentTypes = [.ipa, .bundle]
            }

            guard panel.runModal() == .OK, let url = panel.url else { return }

            await unarchiver.open(at: url)
        }
    }
}


// MARK: - SecondaryButtonStyle

struct SecondaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .foregroundColor(.primary)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.2))
            )
            .animation(.easeInOut, value: configuration.isPressed)
            .onHover { hover in
                withAnimation {
                    if hover {
                        // Your hover state changes
                    } else {
                        // Revert to default state
                    }
                }
            }
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}

extension View {
    func secondaryButtonStyle() -> some View {
        buttonStyle(SecondaryButtonStyle())
    }
}
