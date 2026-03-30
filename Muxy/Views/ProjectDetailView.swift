import SwiftUI

struct ProjectDetailView: View {
    let projectID: UUID
    @Environment(AppState.self) private var appState
    @Environment(ProjectStore.self) private var projectStore

    private var project: Project? {
        projectStore.projects.first { $0.id == projectID }
    }

    var body: some View {
        VStack(spacing: 0) {
            TabBarView(projectID: projectID)
            Divider()
            if let tab = appState.activeTab(for: projectID),
               let project {
                SplitPaneView(tab: tab, projectPath: project.path)
                    .id(tab.id)
            }
        }
        .navigationTitle(project?.name ?? "")
        .navigationSubtitle(appState.activeTab(for: projectID)?.title ?? "")
        .onReceive(NotificationCenter.default.publisher(for: .muxyCreateNewTab)) { notif in
            guard let id = notif.userInfo?["projectID"] as? UUID,
                  id == projectID, let project else { return }
            appState.createTab(for: project)
        }
        .onReceive(NotificationCenter.default.publisher(for: .muxySplitPane)) { notif in
            guard let id = notif.userInfo?["projectID"] as? UUID,
                  id == projectID,
                  let direction = notif.userInfo?["direction"] as? SplitDirection,
                  let project,
                  let tab = appState.activeTab(for: projectID) else { return }
            tab.splitFocusedPane(direction: direction, projectPath: project.path)
        }
    }
}
