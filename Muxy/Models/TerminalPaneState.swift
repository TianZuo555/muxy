import Foundation
import SwiftTerm

@MainActor
@Observable
final class TerminalPaneState: Identifiable {
    let id = UUID()
    let projectPath: String
    var title: String = "Terminal"

    // The actual NSView is created lazily by TerminalPaneView's NSViewRepresentable
    // We store a reference so we can interact with it
    weak var terminalView: LocalProcessTerminalView?

    init(projectPath: String) {
        self.projectPath = projectPath
    }
}
