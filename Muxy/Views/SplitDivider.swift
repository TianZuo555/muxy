import SwiftUI

struct SplitDivider: View {
    let direction: SplitDirection

    var body: some View {
        Rectangle()
            .fill(Color(nsColor: .separatorColor))
            .contentShape(Rectangle())
            .onHover { hovering in
                if hovering {
                    if direction == .horizontal {
                        NSCursor.resizeLeftRight.push()
                    } else {
                        NSCursor.resizeUpDown.push()
                    }
                } else {
                    NSCursor.pop()
                }
            }
    }
}
