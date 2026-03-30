import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "terminal")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("Select or add a project to get started")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
