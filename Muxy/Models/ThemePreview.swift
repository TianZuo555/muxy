import AppKit

struct ThemePreview: Identifiable {
    let name: String
    let background: NSColor
    let foreground: NSColor
    var id: String { name }
}
