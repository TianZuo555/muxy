import SwiftUI

struct TabBarView: View {
    let projectID: UUID
    @Environment(AppState.self) private var appState
    @Environment(ProjectStore.self) private var projectStore

    private var tabs: [TerminalTab] {
        appState.tabsForProject(projectID)
    }

    private var activeTabID: UUID? {
        appState.activeTabID[projectID]
    }

    private var project: Project? {
        projectStore.projects.first { $0.id == projectID }
    }

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 1) {
                    ForEach(tabs) { tab in
                        TabItemView(
                            tab: tab,
                            isActive: tab.id == activeTabID,
                            onSelect: { appState.selectTab(tab.id, projectID: projectID) },
                            onClose: { appState.closeTab(tab.id, projectID: projectID) }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }

            Spacer()

            Button(action: createTab) {
                Image(systemName: "plus")
                    .font(.caption)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
        }
        .frame(height: 34)
        .background(.bar)
    }

    private func createTab() {
        guard let project else { return }
        appState.createTab(for: project)
    }
}
