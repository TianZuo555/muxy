import SwiftUI

struct SplitContainerView: View {
    let branch: SplitBranch
    let focusedPaneID: UUID?
    let onFocus: (UUID) -> Void
    let onSplit: (UUID, SplitDirection) -> Void
    let onClose: (UUID) -> Void

    private let dividerThickness: CGFloat = 2

    var body: some View {
        GeometryReader { geometry in
            let isHorizontal = branch.direction == .horizontal
            let totalSize = isHorizontal ? geometry.size.width : geometry.size.height
            let firstSize = max(0, totalSize * branch.ratio - dividerThickness / 2)
            let secondSize = max(0, totalSize * (1 - branch.ratio) - dividerThickness / 2)

            if isHorizontal {
                HStack(spacing: 0) {
                    childView(node: branch.first)
                        .frame(width: firstSize)

                    SplitDivider(direction: branch.direction)
                        .frame(width: dividerThickness)
                        .gesture(dragGesture(totalSize: totalSize))

                    childView(node: branch.second)
                        .frame(width: secondSize)
                }
            } else {
                VStack(spacing: 0) {
                    childView(node: branch.first)
                        .frame(height: firstSize)

                    SplitDivider(direction: branch.direction)
                        .frame(height: dividerThickness)
                        .gesture(dragGesture(totalSize: totalSize))

                    childView(node: branch.second)
                        .frame(height: secondSize)
                }
            }
        }
    }

    @ViewBuilder
    private func childView(node: SplitNode) -> some View {
        SplitNodeView(
            node: node,
            focusedPaneID: focusedPaneID,
            onFocus: onFocus,
            onSplit: onSplit,
            onClose: onClose
        )
    }

    private func dragGesture(totalSize: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = branch.direction == .horizontal
                    ? value.translation.width
                    : value.translation.height
                let currentFirst = totalSize * branch.ratio
                let newRatio = (currentFirst + delta) / totalSize
                branch.ratio = min(max(newRatio, 0.15), 0.85)
            }
    }
}
