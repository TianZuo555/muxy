import SwiftUI

struct SidebarView: View {
    @Environment(AppState.self) private var appState
    @Environment(ProjectStore.self) private var projectStore

    var body: some View {
        @Bindable var appState = appState
        List(selection: $appState.activeProjectID) {
            ForEach(projectStore.projects) { project in
                SidebarRow(project: project)
                    .tag(project.id)
            }
            .onMove(perform: projectStore.reorder)
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addProject) {
                    Image(systemName: "plus")
                }
            }
        }
        .contextMenu(forSelectionType: UUID.self) { ids in
            if let id = ids.first {
                Button("Remove Project", role: .destructive) {
                    removeProject(id: id)
                }
            }
        }
        .onChange(of: appState.activeProjectID) { _, newID in
            if let newID, let project = projectStore.projects.first(where: { $0.id == newID }) {
                appState.ensureTabExists(for: project)
            }
        }
    }

    private func addProject() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Select a project folder"
        if panel.runModal() == .OK, let url = panel.url {
            let project = Project(
                name: url.lastPathComponent,
                path: url.path(percentEncoded: false),
                sortOrder: projectStore.projects.count
            )
            projectStore.add(project)
            appState.activeProjectID = project.id
        }
    }

    private func removeProject(id: UUID) {
        appState.removeProject(id)
        projectStore.remove(id: id)
    }
}
