import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(ProjectStore.self) private var projectStore

    var body: some View {
        @Bindable var appState = appState
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 320)
        } detail: {
            if let projectID = appState.activeProjectID,
               projectStore.projects.contains(where: { $0.id == projectID }) {
                ProjectDetailView(projectID: projectID)
            } else {
                EmptyStateView()
            }
        }
    }
}
