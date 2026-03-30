import SwiftUI

struct SplitNodeView: View {
    let node: SplitNode
    let focusedPaneID: UUID?
    let onFocus: (UUID) -> Void
    let onSplit: (UUID, SplitDirection) -> Void
    let onClose: (UUID) -> Void

    var body: some View {
        switch node {
        case .pane(let paneState):
            TerminalPaneView(
                paneState: paneState,
                isFocused: focusedPaneID == paneState.id,
                onFocus: { onFocus(paneState.id) },
                onSplit: { direction in onSplit(paneState.id, direction) },
                onClose: { onClose(paneState.id) }
            )

        case .split(let branch):
            SplitContainerView(
                branch: branch,
                focusedPaneID: focusedPaneID,
                onFocus: onFocus,
                onSplit: onSplit,
                onClose: onClose
            )
        }
    }
}
