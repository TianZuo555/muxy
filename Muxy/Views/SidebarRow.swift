import SwiftUI

struct SidebarRow: View {
    let project: Project

    var body: some View {
        Label {
            Text(project.name)
                .lineLimit(1)
        } icon: {
            Image(systemName: project.pathExists ? "folder.fill" : "folder.badge.questionmark")
                .foregroundColor(project.pathExists ? .secondary : .red)
        }
    }
}
