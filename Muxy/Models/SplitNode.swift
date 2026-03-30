import Foundation

enum SplitDirection: Sendable {
    case horizontal // left | right
    case vertical   // top / bottom
}

enum SplitNode: Identifiable {
    case pane(TerminalPaneState)
    indirect case split(SplitBranch)

    var id: UUID {
        switch self {
        case .pane(let pane): pane.id
        case .split(let branch): branch.id
        }
    }
}

@Observable
final class SplitBranch: Identifiable {
    let id = UUID()
    var direction: SplitDirection
    var ratio: CGFloat
    var first: SplitNode
    var second: SplitNode

    init(direction: SplitDirection, ratio: CGFloat = 0.5,
         first: SplitNode, second: SplitNode) {
        self.direction = direction
        self.ratio = ratio
        self.first = first
        self.second = second
    }
}

// MARK: - Tree Operations

extension SplitNode {
    /// Replace the pane with `paneID` with a split containing the old pane and a new pane.
    func splitting(paneID: UUID, direction: SplitDirection, newPane: TerminalPaneState) -> SplitNode {
        switch self {
        case .pane(let pane) where pane.id == paneID:
            return .split(SplitBranch(
                direction: direction,
                first: .pane(pane),
                second: .pane(newPane)
            ))
        case .pane:
            return self
        case .split(let branch):
            branch.first = branch.first.splitting(paneID: paneID, direction: direction, newPane: newPane)
            branch.second = branch.second.splitting(paneID: paneID, direction: direction, newPane: newPane)
            return .split(branch)
        }
    }

    /// Remove the pane with `paneID`, promoting its sibling. Returns nil if tree becomes empty.
    func removing(paneID: UUID) -> SplitNode? {
        switch self {
        case .pane(let pane) where pane.id == paneID:
            return nil
        case .pane:
            return self
        case .split(let branch):
            if case .pane(let p) = branch.first, p.id == paneID {
                return branch.second
            }
            if case .pane(let p) = branch.second, p.id == paneID {
                return branch.first
            }
            if let newFirst = branch.first.removing(paneID: paneID) {
                branch.first = newFirst
                return .split(branch)
            }
            if let newSecond = branch.second.removing(paneID: paneID) {
                branch.second = newSecond
                return .split(branch)
            }
            return self
        }
    }

    /// Collect all leaf panes in tree order.
    func allPanes() -> [TerminalPaneState] {
        switch self {
        case .pane(let pane): [pane]
        case .split(let branch):
            branch.first.allPanes() + branch.second.allPanes()
        }
    }

    /// Find a specific pane by ID.
    func findPane(id: UUID) -> TerminalPaneState? {
        switch self {
        case .pane(let pane): pane.id == id ? pane : nil
        case .split(let branch):
            branch.first.findPane(id: id) ?? branch.second.findPane(id: id)
        }
    }
}
