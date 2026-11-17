import SwiftUI
#if DEBUG
import GitHubAuth
import GitHubAPI
import ProjectStore
import WorkCache
#endif

@main
struct GitViewApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project") || ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-dense") || ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project-grid") || ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-empty-projects") {
                ProjectTestFixture()
            } else {
                ConnectionPage()
            }
            #else
            ConnectionPage()
            #endif
            }
            .onChange(of: scenePhase) {
                if scenePhase == .background { BackgroundRefreshRuntime.schedule() }
            }
        }
        .backgroundTask(.appRefresh(BackgroundRefreshRuntime.identifier)) { await BackgroundRefreshRuntime.run() }
    }
}

#if DEBUG
private struct ProjectTestFixture: View {
    @State private var library: ProjectLibrary?
    @State private var previewSourceTransitions = 0
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            if let library {
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-mock-discovery") {
                    ProjectsPage(library: library, sessionManager: Self.fixtureSession, discovery: Self.fixtureDiscovery, workClient: Self.fixtureWorkClient)
                } else {
                    ProjectsPage(library: library, sessionManager: GitHubSessionManager(load: { nil }, save: { _, _, _ in }, refresh: { _ in throw SessionRefreshError.missingSession }))
                }
            } else { ProgressView() }
        }
        .preferredColorScheme(ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-dark-projects") ? .dark : nil)
        .environment(\.dynamicTypeSize, ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-large-type") ? .accessibility3 : dynamicTypeSize)
        .task {
            do {
                let persistentFixture = ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-history-relaunch")
                let store: ProjectStore
                if persistentFixture {
                    let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fixtureID = ProcessInfo.processInfo.environment["GITGRID_UI_FIXTURE_ID"].flatMap(UUID.init(uuidString:)) ?? UUID()
                    let directory = base.appendingPathComponent("GitGridUITests/\(fixtureID.uuidString)", isDirectory: true)
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                    store = try ProjectStore(url: directory.appendingPathComponent("projects.sqlite"))
                } else { store = try ProjectStore(inMemory: true) }
                let library = try ProjectLibrary(accountID: 1, store: store)
                if persistentFixture && !library.projects.isEmpty { self.library = library; return }
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-empty-projects") { self.library = library; return }
                let fixtureNodeID = ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-return-overview") ? "fixture-node" : nil
                try library.create(name: "Fixture Project", repository: RepositoryReference(id: 101, fullName: "fixture/one", isPrivate: false, nodeID: fixtureNodeID))
                guard let id = library.projects.first?.id else { return }
                try library.add(repository: RepositoryReference(id: 102, fullName: "fixture/two", isPrivate: true), to: id)
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-missing-repository-multiple") {
                    try library.create(name: "Another Project", repository: RepositoryReference(id: 102, fullName: "fixture/two", isPrivate: true))
                }
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-paused-repository") {
                    try library.setSyncPaused(true, repositoryID: 101, projectID: id)
                }
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project-grid") {
                    for index in 1...11 {
                        try library.create(name: "Fixture Project \(index)", repository: RepositoryReference(id: Int64(200 + index), fullName: "fixture/\(index)", isPrivate: false))
                    }
                }
                let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
                let now = Date()
                let stamp = now.timeIntervalSinceReferenceDate
                let json = #"[{"id":"I1","number":1,"title":"Offline fixture","url":"https://github.com/fixture/one/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue","details":{"body":"Saved synthetic description","issueContext":{"repository":"fixture/one","type":"Bug","assignees":["alice"],"assigneesTotal":2,"assigneesComplete":false,"milestone":"First release","participantCount":7,"commentCount":4},"issueRelationships":{"parent":{"id":"IP","number":8,"title":"Parent fixture","url":"https://github.com/fixture/one/issues/8","state":"OPEN","repository":"fixture/one"},"parentObserved":true,"blockedBy":{"items":[{"id":"IB","number":9,"title":"Blocker fixture","url":"https://github.com/fixture/one/issues/9","state":"OPEN","repository":"fixture/one"}],"total":2,"isComplete":false},"blocking":{"items":[],"total":0,"isComplete":true},"subIssues":{"items":[],"total":0,"isComplete":true},"pullRequests":{"items":[{"id":"PRLINK","number":12,"title":"Linked PR fixture","url":"https://github.com/fixture/one/pull/12","state":"OPEN","repository":"fixture/one","willCloseTarget":true,"crossReferenced":true,"manuallyLinked":true}],"isComplete":false,"manualLinksComplete":true}},"observedAt":0}},{"id":"I2","number":4,"title":"Completed fixture","url":"https://github.com/fixture/one/issues/4","state":"CLOSED","updatedAt":\#(stamp),"closedAt":\#(stamp),"closureReason":"COMPLETED","isDraft":false,"kind":"issue"},{"id":"I3","number":5,"title":"Not planned fixture","url":"https://github.com/fixture/one/issues/5","state":"CLOSED","updatedAt":\#(stamp),"closedAt":\#(stamp),"closureReason":"NOT_PLANNED","isDraft":false,"kind":"issue"},{"id":"P1","number":2,"title":"Merged fixture","url":"https://github.com/fixture/one/pull/2","state":"MERGED","updatedAt":\#(stamp),"mergedAt":\#(stamp),"isDraft":false,"kind":"pullRequest"},{"id":"P2","number":3,"title":"Failed fixture","url":"https://github.com/fixture/one/pull/3","state":"OPEN","updatedAt":\#(stamp),"isDraft":true,"kind":"pullRequest","checkStatus":"FAILURE","reviewDecision":"CHANGES_REQUESTED","reviewRequestCount":1,"reviewThreads":{"total":3,"observedUnresolved":2,"isComplete":false}}]"#
                let items: [GitHubWorkItem]
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-dense") {
                    items = try denseItems(stamp: stamp)
                } else {
                    var fixture = ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-unsafe-source-link")
                        ? json.replacingOccurrences(of: "https://github.com/fixture/one/issues/1", with: "https://github.com/fixture/one/issues/1?token=synthetic")
                        : json
                    if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-large-number") {
                        fixture = fixture.replacingOccurrences(of: #""number":3,"title":"Failed fixture""#, with: #""number":1131,"title":"Failed fixture""#)
                            .replacingOccurrences(of: "/pull/3", with: "/pull/1131")
                    }
                    items = try JSONDecoder().decode([GitHubWorkItem].self, from: Data(fixture.utf8))
                }
                let secondItems: [GitHubWorkItem]
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-missing-repository-work") {
                    let saved = #"[{"id":"I102","number":9,"title":"Saved private work","url":"https://github.com/fixture/two/issues/9","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue"}]"#
                    secondItems = try JSONDecoder().decode([GitHubWorkItem].self, from: Data(saved.utf8))
                } else { secondItems = [] }
                var archive = ProjectWorkArchive().applying([
                    .init(id: 101, name: "fixture/one", outcome: .received(items, complete: true)),
                    .init(id: 102, name: "fixture/two", outcome: .received(secondItems, complete: true))
                ], at: now)
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-preview-failure") {
                    archive = archive.applyingPartial([
                        .init(id: 101, name: "fixture/one", outcome: .failed("GitHub HTTP 403"))
                    ], in: [101, 102], at: now)
                }
                try cache.save(accountID: 1, projectID: id, payload: JSONEncoder().encode(archive), observedAt: now, complete: true)
                self.library = library
            } catch { assertionFailure("Could not create UI test fixture: \(error)") }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background, ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-preview-source-change"),
               let project = library?.projects.first {
                do {
                    let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let cache = try WorkCache(url: base.appendingPathComponent("GitGrid/WorkCache.sqlite"))
                    guard let snapshot = try cache.load(accountID: project.accountID, projectID: project.id) else { return }
                    let archive = try ProjectWorkArchive.decode(snapshot.payload)
                    guard let repository = archive.repositories.first(where: { $0.id == 101 }) else { return }
                    previewSourceTransitions += 1
                    let outcome: RepositoryWorkRefresh.Outcome = previewSourceTransitions == 1
                        ? .failed("GitHub HTTP 403") : .received(repository.items, complete: true)
                    let updated = archive.applyingPartial([.init(id: 101, name: repository.name, outcome: outcome)],
                        in: Set(project.repositories.map(\.id)), at: .now)
                    _ = try cache.replacePayload(accountID: project.accountID, projectID: project.id,
                                                 expected: snapshot, payload: JSONEncoder().encode(updated))
                } catch { assertionFailure("Could not update preview source fixture: \(error)") }
                return
            }
            guard scenePhase == .background, ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-overview-refresh"),
                  let project = library?.projects.first else { return }
            do {
                let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let cache = try WorkCache(url: base.appendingPathComponent("GitGrid/WorkCache.sqlite"))
                let now = Date()
                let archive = ProjectWorkArchive().applying(project.repositories.map {
                    .init(id: $0.id, name: $0.fullName, outcome: .received([], complete: true), observedAt: now)
                }, at: now)
                try cache.save(accountID: project.accountID, projectID: project.id, payload: JSONEncoder().encode(archive), observedAt: now, complete: true)
            } catch { assertionFailure("Could not update UI test overview: \(error)") }
        }
    }

    private static let fixtureSession: GitHubSessionManager = {
        let json = #"{"identity":{"id":1,"login":"fixture"},"accessToken":"synthetic"}"#
        let credential = try! JSONDecoder().decode(SavedGitHubCredential.self, from: Data(json.utf8))
        return GitHubSessionManager(load: { credential }, save: { _, _, _ in }, refresh: { _ in throw SessionRefreshError.missingSession })
    }()

    private static let fixtureDiscovery: GitHubDiscovery = {
        let arguments = ProcessInfo.processInfo.arguments
        let transport = DiscoveryFixtureTransport(failFirst: arguments.contains("--gitgrid-ui-test-discovery-retry"),
                                                  emptyFirst: arguments.contains("--gitgrid-ui-test-discovery-empty"),
                                                  partialRefresh: arguments.contains("--gitgrid-ui-test-discovery-partial"),
                                                  historyMembership: arguments.contains("--gitgrid-ui-test-history-membership"))
        return GitHubDiscovery(client: GitHubDiscoveryClient { request in await transport.send(request) })
    }()

    private static let fixtureWorkClient = GitHubWorkClient { request in
        let body = #"{"data":{"node":{"id":"fixture-node","fullDatabaseId":"101","nameWithOwner":"fixture/one","isPrivate":false,"issues":{"nodes":[{"id":"fixture-issue","number":7,"title":"Synthetic issue","url":"https://github.com/fixture/one/issues/7","state":"OPEN","updatedAt":"2026-01-01T00:00:00Z"}],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
        let responseBody = ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-return-overview")
            ? body.replacingOccurrences(of: #","nameWithOwner":"fixture/one","isPrivate":false"#, with: "")
            : body
        return (Data(responseBody.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }

    private func denseItems(stamp: TimeInterval) throws -> [GitHubWorkItem] {
        let count = ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-large-summary") ? 1_000 : 100
        let values: [[String: Any]] = (1...count).map { index in
            let issue = index.isMultiple(of: 3)
            let state = issue ? (index.isMultiple(of: 2) ? "CLOSED" : "OPEN") :
                (index % 4 == 2 ? "MERGED" : (index % 4 == 0 ? "CLOSED" : "OPEN"))
            let updated = stamp - Double(index)
            var item: [String: Any] = ["id": "D\(index)", "number": index, "title": "Synthetic work \(index)",
                "url": "https://github.com/fixture/one/\(issue ? "issues" : "pull")/\(index)", "state": state,
                "updatedAt": updated, "isDraft": !issue && state == "OPEN" && index.isMultiple(of: 5),
                "kind": issue ? "issue" : "pullRequest"]
            if state == "CLOSED" || state == "MERGED" { item["closedAt"] = stamp }
            if state == "MERGED" { item["mergedAt"] = stamp }
            if !issue && state == "OPEN" { item["checkStatus"] = ["FAILURE", "PENDING", "SUCCESS"][index % 5 % 3] }
            return item
        }
        return try JSONDecoder().decode([GitHubWorkItem].self, from: JSONSerialization.data(withJSONObject: values))
    }
}

private actor DiscoveryFixtureTransport {
    private var failFirst: Bool
    private var emptyFirst: Bool
    private let partialRefresh: Bool
    private let historyMembership: Bool
    private var cycle = 0
    init(failFirst: Bool, emptyFirst: Bool, partialRefresh: Bool, historyMembership: Bool) {
        self.failFirst = failFirst; self.emptyFirst = emptyFirst; self.partialRefresh = partialRefresh
        self.historyMembership = historyMembership
    }
    func send(_ request: URLRequest) -> (Data, HTTPURLResponse) {
        if failFirst {
            failFirst = false
            return (Data(), HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!)
        }
        if emptyFirst {
            emptyFirst = false
            let body = #"{"total_count":0,"installations":[]}"#
            return (Data(body.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        if partialRefresh {
            if request.url?.path == "/user/installations" {
                cycle += 1
                let body = #"{"total_count":1,"installations":[{"id":1}]}"#
                return (Data(body.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
            }
            let page = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)?.queryItems?.first { $0.name == "page" }?.value
            if cycle == 2 && page == "2" {
                return (Data(), HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!)
            }
            let second = cycle == 2 ? #"{"id":103,"full_name":"fixture/three","private":false}"# : #"{"id":102,"full_name":"fixture/two","private":false}"#
            let body = #"{"total_count":2,"repositories":[{"id":101,"full_name":"fixture/one","private":false},\#(second)]}"#
            let header = cycle == 2 ? ["Link": "<https://api.github.com/user/installations/1/repositories?page=2>; rel=\"next\""] : [:]
            return (Data(body.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: header)!)
        }
        if historyMembership && request.url?.path != "/user/installations" {
            let body = #"{"total_count":2,"repositories":[{"id":101,"full_name":"fixture/one","private":false,"node_id":"fixture-node"},{"id":103,"full_name":"fixture/three","private":false,"node_id":"fixture-three"}]}"#
            return (Data(body.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let body = request.url?.path == "/user/installations"
            ? #"{"total_count":1,"installations":[{"id":1}]}"#
            : #"{"total_count":1,"repositories":[{"id":101,"full_name":"fixture/one","private":false,"node_id":"fixture-node"}]}"#
        return (Data(body.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}
#endif
