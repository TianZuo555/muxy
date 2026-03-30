import SwiftUI

struct SplitPaneView: View {
    let tab: TerminalTab
    let projectPath: String

    var body: some View {
        SplitNodeView(
            node: tab.rootNode,
            focusedPaneID: tab.focusedPaneID,
            onFocus: { tab.focusedPaneID = $0 },
            onSplit: { paneID, direction in
                let newPane = TerminalPaneState(projectPath: projectPath)
                tab.rootNode = tab.rootNode.splitting(
                    paneID: paneID,
                    direction: direction,
                    newPane: newPane
                )
                tab.focusedPaneID = newPane.id
            },
            onClose: { paneID in
                if let newRoot = tab.rootNode.removing(paneID: paneID) {
                    tab.rootNode = newRoot
                    tab.focusedPaneID = newRoot.allPanes().first?.id
                }
            }
        )
    }
}
