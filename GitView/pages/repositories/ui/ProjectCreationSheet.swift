import GitHubAPI
import ProjectStore
import SwiftUI

struct ProjectCreationSheet: View {
    let repository: GitHubRepository
    let library: ProjectLibrary
    let canSave: Bool
    var preferredProjectID: UUID? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var destination: UUID?
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Picker("Project", selection: $destination) {
                    Text("New Project").tag(UUID?.none)
                    ForEach(library.projects) { project in Text(project.name).tag(Optional(project.id)) }
                }
                if destination == nil { TextField("Project name", text: $name) }
                LabeledContent("Repository", value: repository.fullName)
                if !canSave {
                    Text("Repository access needs to be refreshed before saving.")
                        .foregroundStyle(.secondary)
                }
                if let errorMessage { Text(errorMessage).foregroundStyle(.secondary) }
            }
            .navigationTitle("Add Repository")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave || (destination == nil && name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                }
            }
            .onAppear {
                name = repository.fullName.split(separator: "/").last.map(String.init) ?? repository.fullName
                if let preferredProjectID, library.projects.contains(where: { $0.id == preferredProjectID }) {
                    destination = preferredProjectID
                }
            }
        }
    }

    @MainActor private func save() {
        do {
            let reference = RepositoryReference(id: repository.id, fullName: repository.fullName, isPrivate: repository.isPrivate, nodeID: repository.nodeID)
            if let destination { try library.add(repository: reference, to: destination) }
            else { try library.create(name: name, repository: reference) }
            dismiss()
        } catch {
            errorMessage = "Could not save the project. Please try again."
        }
    }
}
