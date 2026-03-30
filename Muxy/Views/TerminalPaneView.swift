import SwiftUI
import SwiftTerm

struct TerminalPaneView: View {
    let paneState: TerminalPaneState
    let isFocused: Bool
    let onFocus: () -> Void
    let onSplit: (SplitDirection) -> Void
    let onClose: () -> Void

    var body: some View {
        SwiftTermView(paneState: paneState, onFocus: onFocus)
            .overlay {
                if isFocused {
                    Rectangle()
                        .strokeBorder(Color.accentColor.opacity(0.5), lineWidth: 1)
                        .allowsHitTesting(false)
                }
            }
    }
}

// MARK: - NSViewRepresentable wrapper for SwiftTerm

struct SwiftTermView: NSViewRepresentable {
    let paneState: TerminalPaneState
    let onFocus: () -> Void

    func makeNSView(context: Context) -> LocalProcessTerminalView {
        let terminalView = LocalProcessTerminalView(frame: .zero)
        terminalView.processDelegate = context.coordinator
        terminalView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        terminalView.configureNativeColors()

        let shell = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        terminalView.startProcess(
            executable: shell,
            currentDirectory: paneState.projectPath
        )

        paneState.terminalView = terminalView
        return terminalView
    }

    func updateNSView(_ nsView: LocalProcessTerminalView, context: Context) {
        // No dynamic updates needed — the terminal manages itself
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(paneState: paneState, onFocus: onFocus)
    }

    @MainActor
    final class Coordinator: NSObject, LocalProcessTerminalViewDelegate {
        let paneState: TerminalPaneState
        let onFocus: () -> Void

        init(paneState: TerminalPaneState, onFocus: @escaping () -> Void) {
            self.paneState = paneState
            self.onFocus = onFocus
        }

        // MARK: - LocalProcessTerminalViewDelegate

        nonisolated func sizeChanged(source: LocalProcessTerminalView, newCols: Int, newRows: Int) {
        }

        nonisolated func setTerminalTitle(source: LocalProcessTerminalView, title: String) {
            Task { @MainActor in
                self.paneState.title = title
            }
        }

        nonisolated func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {
        }

        nonisolated func processTerminated(source: TerminalView, exitCode: Int32?) {
        }
    }
}
