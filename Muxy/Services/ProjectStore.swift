import Foundation

@MainActor
@Observable
final class ProjectStore {
    private(set) var projects: [Project] = []

    private let fileURL: URL = {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Muxy", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("projects.json")
    }()

    init() {
        load()
    }

    func add(_ project: Project) {
        projects.append(project)
        save()
    }

    func remove(id: UUID) {
        projects.removeAll { $0.id == id }
        save()
    }

    func reorder(fromOffsets source: IndexSet, toOffset destination: Int) {
        projects.move(fromOffsets: source, toOffset: destination)
        for (index, project) in projects.enumerated() {
            project.sortOrder = index
        }
        save()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(projects)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save projects: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            projects = try JSONDecoder().decode([Project].self, from: data)
            projects.sort { $0.sortOrder < $1.sortOrder }
        } catch {
            print("Failed to load projects: \(error)")
        }
    }
}
