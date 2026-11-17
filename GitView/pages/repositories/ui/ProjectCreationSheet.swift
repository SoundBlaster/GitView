import GitHubAPI
import ProjectStore
import SwiftUI

struct ProjectCreationSheet: View {
    let repository: GitHubRepository
    let library: ProjectLibrary
    let canSave: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Project name", text: $name)
                LabeledContent("Repository", value: repository.fullName)
                if !canSave {
                    Text("Repository access needs to be refreshed before saving.")
                        .foregroundStyle(.secondary)
                }
                if let errorMessage { Text(errorMessage).foregroundStyle(.secondary) }
            }
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { name = repository.fullName.split(separator: "/").last.map(String.init) ?? repository.fullName }
        }
    }

    @MainActor private func save() {
        do {
            try library.create(name: name, repository: RepositoryReference(id: repository.id, fullName: repository.fullName, isPrivate: repository.isPrivate))
            dismiss()
        } catch {
            errorMessage = "Could not save the project. Please try again."
        }
    }
}
