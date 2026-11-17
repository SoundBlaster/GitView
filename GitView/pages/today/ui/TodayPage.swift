import SwiftUI
import WorkDomain

struct TodayPage: View {
    let items: [DemoWork.Item]
    @State private var columns = 8
    @State private var width: CGFloat = 0
    @State private var selected: DemoWork.Item?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var effectiveColumns: Int { dynamicTypeSize.isAccessibilitySize ? min(columns, 2) : columns }
    private var gridColumns: [GridItem] { Array(repeating: GridItem(.flexible(), spacing: 4), count: effectiveColumns) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Demo data · GitHub is not connected")
                    .font(.footnote).foregroundStyle(.secondary)
                LazyVGrid(columns: gridColumns, spacing: 4) {
                    ForEach(items) { item in
                        Button { selected = item } label: {
                            WorkCell(item: item, expanded: effectiveColumns <= 2)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("demo.work.\(item.id)")
                        .contextMenu {
                            Button("View demo details") { selected = item }
                        } preview: {
                            Text("Demo pull request #\(item.id)").font(.headline).padding()
                        }
                    }
                }
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
            }.padding()
        }
        .highPriorityGesture(MagnifyGesture().onEnded { value in
            if value.magnification > 1.15 { changeZoom(.larger) }
            else if value.magnification < 0.85 { changeZoom(.smaller) }
        })
        .navigationTitle("Today · Demo")
        .toolbar {
            Menu("Zoom", systemImage: "plus.magnifyingglass") {
                Button("Larger", systemImage: "plus.magnifyingglass") { changeZoom(.larger) }
                Button("Smaller", systemImage: "minus.magnifyingglass") { changeZoom(.smaller) }
            }
        }
        .sheet(item: $selected) { item in
            NavigationStack {
                List {
                    LabeledContent("Demo pull request", value: "#\(item.id)")
                    LabeledContent("State", value: item.completed ? "Merged" : "Open")
                }.navigationTitle("Demo details")
            }
        }
    }

    private func changeZoom(_ direction: GridZoomDirection) {
        let next = GridDensity.next(current: effectiveColumns, direction: direction, width: Double(width), maxCellWidth: 320)
        withAnimation(.easeInOut(duration: 0.2)) { columns = next }
    }
}

private struct WorkCell: View {
    let item: DemoWork.Item
    let expanded: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(item.completed ? Color.green.opacity(0.25) : Color.blue.opacity(0.25))
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 320)
            .overlay {
                VStack {
                    Image(systemName: item.completed ? "checkmark" : "arrow.trianglehead.pull")
                    if expanded { Text("#\(item.id) · \(item.completed ? "Merged" : "Open")").font(.caption) }
                }.foregroundStyle(item.completed ? .green : .blue)
            }
            .accessibilityLabel("Demo pull request \(item.id), \(item.completed ? "merged" : "open")")
    }
}
