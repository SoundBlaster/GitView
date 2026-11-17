import XCTest

@MainActor final class ProjectCompositionUITests: XCTestCase {
    func testEmptyProjectsCanOpenRepositoryDiscoveryAndReturn() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-empty-projects")
        app.launch()
        let choose = app.buttons["projects.chooseRepository"]
        XCTAssertTrue(choose.waitForExistence(timeout: 10))
        choose.tap()
        XCTAssertTrue(app.navigationBars["Repositories"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.descendants(matching: .any)["discovery.installApp"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(choose.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["projects.addRepository"].exists)
    }
    func testProjectZoomKeepsVisibleProjectAfterScrolling() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project-grid")
        app.launch()
        let scroll = app.scrollViews.firstMatch
        let query = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project."))
        XCTAssertTrue(query.firstMatch.waitForExistence(timeout: 10))
        scroll.pinch(withScale: 1.6, velocity: 1)
        scroll.swipeUp()
        let visible = query.allElementsBoundByIndex.filter {
            $0.isHittable && scroll.frame.contains(CGPoint(x: $0.frame.midX, y: $0.frame.midY))
        }.sorted { $0.frame.midY < $1.frame.midY }
        XCTAssertGreaterThan(visible.count, 1)
        guard visible.count > 1 else { return }
        let name = visible[visible.count / 2].identifier
        scroll.pinch(withScale: 1.6, velocity: 1)
        expectation(for: NSPredicate(format: "isHittable == true"), evaluatedWith: app.buttons[name])
        waitForExpectations(timeout: 5)
        scroll.pinch(withScale: 0.6, velocity: -1)
        expectation(for: NSPredicate(format: "isHittable == true"), evaluatedWith: app.buttons[name])
        waitForExpectations(timeout: 5)
        XCTAssertFalse(app.buttons["project.settings"].exists)
    }
    func testZoomKeepsVisibleWorkAfterScrolling() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-dense")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let scroll = app.scrollViews.firstMatch
        XCTAssertTrue(app.buttons["work.D1"].waitForExistence(timeout: 10))
        scroll.pinch(withScale: 1.6, velocity: 1)
        scroll.pinch(withScale: 1.6, velocity: 1)
        scroll.swipeUp()
        scroll.swipeUp()
        let cells = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "work.D")).allElementsBoundByIndex
        let visible = cells.filter { $0.isHittable && scroll.frame.contains(CGPoint(x: $0.frame.midX, y: $0.frame.midY)) }
            .sorted { $0.frame.midY < $1.frame.midY }
        XCTAssertGreaterThan(visible.count, 4)
        guard visible.count > 4 else { return }
        let target = app.buttons[visible[visible.count / 2].identifier]
        let name = target.identifier
        scroll.pinch(withScale: 1.6, velocity: 1)
        let expected = NSPredicate(format: "isHittable == true")
        expectation(for: expected, evaluatedWith: app.buttons[name])
        waitForExpectations(timeout: 5)
        scroll.pinch(withScale: 0.6, velocity: -1)
        expectation(for: expected, evaluatedWith: app.buttons[name])
        waitForExpectations(timeout: 5)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Grid after zoom in and out"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    func testPausedRepositoryCanResumeFromProjectSettings() throws {
        let app = XCUIApplication()
        app.launchArguments += ["--gitgrid-ui-test-project", "--gitgrid-ui-test-paused-repository"]
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["project.settings"].waitForExistence(timeout: 10))
        app.buttons["project.settings"].tap()
        XCTAssertTrue(app.staticTexts["Synchronization paused"].waitForExistence(timeout: 5))
        let resume = app.buttons["Resume sync"]
        XCTAssertTrue(resume.waitForExistence(timeout: 5))
        resume.tap()
        XCTAssertTrue(app.staticTexts["Synchronization paused"].waitForNonExistence(timeout: 5))
    }
    func testEraseSavedWorkPausesRepositoryAndKeepsProject() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["work.I1"].waitForExistence(timeout: 10))
        app.buttons["project.settings"].tap()
        let repository = app.descendants(matching: .any)["repository.101"].firstMatch
        XCTAssertTrue(repository.waitForExistence(timeout: 10))
        repository.swipeLeft()
        app.buttons["Erase saved work"].firstMatch.tap()
        let dialog = app.sheets.firstMatch
        XCTAssertTrue(dialog.waitForExistence(timeout: 5))
        dialog.buttons["Erase saved work"].tap()
        XCTAssertTrue(app.staticTexts["Synchronization paused"].waitForExistence(timeout: 5))
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["work.I1"].waitForNonExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "synchronization paused")).firstMatch.exists)
        XCTAssertFalse(app.staticTexts["No work in Today"].exists)
        app.buttons["project.settings"].tap()
        let resume = app.buttons["Resume sync"]
        XCTAssertTrue(resume.waitForExistence(timeout: 5))
        resume.tap()
        XCTAssertTrue(app.staticTexts["Synchronization paused"].waitForNonExistence(timeout: 5))
    }
    func testIssuePreviewKeepsSavedDescriptionAndSourceLimitation() throws {
        let app = XCUIApplication()
        app.launchArguments += ["--gitgrid-ui-test-project", "--gitgrid-ui-test-preview-failure"]
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let issue = app.buttons["work.I1"]
        XCTAssertTrue(issue.waitForExistence(timeout: 10))
        issue.press(forDuration: 1)
        app.buttons["Preview"].tap()
        XCTAssertTrue(app.navigationBars["Preview"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["preview.description"].label, "Saved synthetic description")
        XCTAssertTrue(app.descendants(matching: .any)["preview.sourceProblem"].label.contains("GitHub HTTP 403"))
        XCTAssertTrue(app.staticTexts["preview.sourceObservedAt"].label.hasPrefix("Last complete observation"))
        app.buttons["Open in GitGrid"].tap()
        XCTAssertTrue(app.navigationBars["Issue"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["detail.sourceProblem"].label.contains("GitHub HTTP 403"))
        XCTAssertTrue(app.staticTexts["detail.sourceObservedAt"].label.hasPrefix("Last complete observation"))
        XCTAssertTrue(app.descendants(matching: .any)["detail.manageAccess"].exists)
        for _ in 0..<4 where !app.staticTexts["Saved synthetic description"].exists { app.swipeUp() }
        XCTAssertTrue(app.staticTexts["Saved synthetic description"].exists)
        for _ in 0..<6 where !app.buttons["detail.retry"].exists { app.swipeUp() }
        let retry = app.buttons["detail.retry"]
        XCTAssertTrue(retry.waitForExistence(timeout: 10))
        retry.tap()
        XCTAssertTrue(retry.waitForExistence(timeout: 10))
        for _ in 0..<6 where !app.staticTexts["Saved synthetic description"].exists { app.swipeDown() }
        XCTAssertTrue(app.staticTexts["Saved synthetic description"].exists)
    }
    func testPreviewActionKeepsTheSelectedWorkItem() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let item = app.buttons["work.P2"]
        XCTAssertTrue(item.waitForExistence(timeout: 10))
        item.press(forDuration: 1)
        let preview = app.buttons["Preview"]
        XCTAssertTrue(preview.waitForExistence(timeout: 5))
        preview.tap()
        XCTAssertTrue(app.navigationBars["Preview"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Failed fixture"].exists)
        app.buttons["Open in GitGrid"].tap()
        XCTAssertTrue(app.navigationBars["Pull Request"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Failed fixture"].exists)
    }
    func testRepositoryDiscoveryOffersGitHubAccessManagementOffline() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["project.settings"].waitForExistence(timeout: 10))
        app.buttons["project.settings"].tap()
        app.buttons["Add Repository"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["discovery.installApp"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.descendants(matching: .any)["discovery.manageAccess"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Could not refresh repositories for connected account."].waitForExistence(timeout: 10))
    }

    func testConfiguredGitHubConnectionStartsAuthorization() throws {
        let app = XCUIApplication()
        app.launch()
        let connect = app.buttons["Connect GitHub"]
        XCTAssertTrue(connect.waitForExistence(timeout: 10))
        connect.tap()
        if app.staticTexts["GitHub App is not configured yet."].waitForExistence(timeout: 2) {
            throw XCTSkip("Local GitHub App credentials are not configured.")
        }
        let system = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let prompt = system.alerts.firstMatch
        XCTAssertTrue(prompt.waitForExistence(timeout: 15))
        let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        screenshot.name = "GitHub authorization system prompt"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        XCTAssertTrue(prompt.label.localizedCaseInsensitiveContains("github"))
        XCTAssertTrue(prompt.label.contains("GitGrid"))
        prompt.buttons["Cancel"].tap()
        let enabled = NSPredicate(format: "isEnabled == true")
        expectation(for: enabled, evaluatedWith: connect)
        waitForExpectations(timeout: 10)
        XCTAssertFalse(app.staticTexts["Could not complete GitHub connection. Please try again."].exists)
    }

    func testPreviewCanOpenTheSameWorkItem() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-dense")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let item = app.buttons["work.D1"]
        XCTAssertTrue(item.waitForExistence(timeout: 10))
        XCTAssertTrue(item.label.contains("fixture/one"))
        item.press(forDuration: 1)
        let preview = app.staticTexts["Synthetic work 1"]
        XCTAssertTrue(preview.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["fixture/one"].exists)
        app.buttons["Open in GitGrid"].tap()
        XCTAssertTrue(app.navigationBars["Pull Request"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Synthetic work 1"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["work.repository"].label.contains("fixture/one"))
    }

    func testOpenProjectLoadsChangedSnapshotAfterForegroundReturn() throws {
        let app = XCUIApplication()
        app.launchArguments += ["--gitgrid-ui-test-project", "--gitgrid-ui-test-overview-refresh"]
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let oldItem = app.buttons["work.P2"]
        XCTAssertTrue(oldItem.waitForExistence(timeout: 10))
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(oldItem.waitForNonExistence(timeout: 10))
        XCTAssertTrue(app.buttons["project.filters"].exists)
    }

    func testProjectOverviewLoadsChangedSnapshotAfterForegroundReturn() throws {
        let app = XCUIApplication()
        app.launchArguments += ["--gitgrid-ui-test-project", "--gitgrid-ui-test-overview-refresh"]
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        XCTAssertTrue(project.label.contains("1 pull requests with failed CI"))
        XCUIDevice.shared.press(.home)
        app.activate()
        let updated = NSPredicate(format: "label CONTAINS %@", "0 pull requests with failed CI")
        expectation(for: updated, evaluatedWith: project)
        waitForExpectations(timeout: 10)
    }

    func testProjectRestoresGridAndFilterAfterReturningToForeground() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-dense")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["work.D1"].waitForExistence(timeout: 10))
        app.buttons["project.filters"].tap()
        app.buttons["Merged"].tap()
        XCTAssertTrue(app.buttons["work.D2"].waitForNonExistence(timeout: 5))
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(app.buttons["work.D1"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["work.D2"].exists)
        XCTAssertTrue(app.buttons["project.filters"].exists)
    }

    func testDemoGridPinchDoesNotOpenDetails() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["View demo"].tap()
        let item = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "demo.work.")).firstMatch
        XCTAssertTrue(item.waitForExistence(timeout: 10))
        let initialWidth = item.frame.width
        app.scrollViews.firstMatch.pinch(withScale: 1.6, velocity: 1)
        XCTAssertGreaterThan(item.frame.width, initialWidth)
        XCTAssertFalse(app.navigationBars["Demo details"].exists)
        let expandedWidth = item.frame.width
        app.scrollViews.firstMatch.pinch(withScale: 0.6, velocity: -1)
        XCTAssertLessThan(item.frame.width, expandedWidth)
        XCTAssertFalse(app.navigationBars["Demo details"].exists)
        item.tap()
        XCTAssertTrue(app.navigationBars["Demo details"].waitForExistence(timeout: 10))
    }
    func testProjectGridPinchDoesNotOpenProject() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project-grid")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        let initialWidth = project.frame.width
        app.scrollViews.firstMatch.pinch(withScale: 1.6, velocity: 1)
        XCTAssertGreaterThan(project.frame.width, initialWidth)
        XCTAssertFalse(app.buttons["project.settings"].exists)
        let expandedWidth = project.frame.width
        app.scrollViews.firstMatch.pinch(withScale: 0.6, velocity: -1)
        XCTAssertLessThan(project.frame.width, expandedWidth)
        XCTAssertFalse(app.buttons["project.settings"].exists)
        project.tap()
        XCTAssertTrue(app.buttons["project.settings"].waitForExistence(timeout: 10))
    }
    func testHundredItemGridPinchAndPreviewKeepFilter() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-dense")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let first = app.buttons["work.D1"]
        XCTAssertTrue(first.waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["work.D2"].exists)
        app.buttons["project.filters"].tap()
        app.buttons["Merged"].tap()
        XCTAssertTrue(app.buttons["work.D2"].waitForNonExistence(timeout: 5))
        let initialWidth = first.frame.width
        app.scrollViews.firstMatch.pinch(withScale: 1.6, velocity: 1)
        XCTAssertGreaterThan(first.frame.width, initialWidth)
        XCTAssertFalse(app.navigationBars["Pull Request"].exists)
        XCTAssertFalse(app.buttons["work.D2"].exists)
        let expandedWidth = first.frame.width
        app.scrollViews.firstMatch.pinch(withScale: 0.6, velocity: -1)
        XCTAssertLessThan(first.frame.width, expandedWidth)
        XCTAssertFalse(app.navigationBars["Pull Request"].exists)
        XCTAssertFalse(app.buttons["work.D2"].exists)
        first.press(forDuration: 1)
        XCTAssertTrue(app.staticTexts["Synthetic work 1"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Open on GitHub"].exists)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "100 item grid long press preview"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    func testHundredItemGridKeepsSelectionAcrossOpenAndFilter() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-dense")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["work.D1"].waitForExistence(timeout: 10))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "100 synthetic work items"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        let last = app.buttons["work.D100"]
        for _ in 0..<8 where !last.isHittable { app.swipeUp() }
        XCTAssertTrue(last.waitForExistence(timeout: 5))
        XCTAssertTrue(last.isHittable)
        last.tap()
        XCTAssertTrue(app.staticTexts["Synthetic work 100"].waitForExistence(timeout: 10))
        app.buttons["Done"].tap()
        XCTAssertTrue(last.waitForExistence(timeout: 5))
        XCTAssertTrue(last.isHittable)
        app.buttons["project.filters"].tap()
        app.buttons["Merged"].tap()
        XCTAssertTrue(app.buttons["work.D98"].waitForNonExistence(timeout: 5))
        app.buttons["project.filters"].tap()
        app.buttons["Merged"].tap()
        XCTAssertTrue(app.buttons["work.D98"].waitForExistence(timeout: 5))
    }
    func testDenseGridExposesTypeStateAndDraft() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let merged = app.buttons["work.P1"]
        let draft = app.buttons["work.P2"]
        let issue = app.buttons["work.I3"]
        XCTAssertTrue(merged.waitForExistence(timeout: 10))
        XCTAssertTrue(merged.label.contains("Pull request 2") && merged.label.contains("MERGED"))
        XCTAssertTrue(draft.label.contains("draft") && draft.label.contains("FAILURE"))
        XCTAssertTrue(draft.label.contains("review needs attention"))
        XCTAssertTrue(issue.label.contains("Issue 5") && issue.label.contains("CLOSED"))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Dense work grid"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    func testProjectThreadSignalKeepsItsPartialOrigin() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.press(forDuration: 1)
        let signal = app.buttons["Show unresolved review threads"]
        XCTAssertTrue(signal.waitForExistence(timeout: 5))
        signal.tap()
        XCTAssertTrue(app.staticTexts["Failed fixture"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["The origin observation was partial or had unavailable data."].exists)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Origin: 1 pull requests")).firstMatch.exists)
    }
    func testProjectSignalOpensItsSelectionWithoutChangingGridFilter() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["work.P2"].waitForExistence(timeout: 10))
        app.buttons["project.filters"].tap()
        app.buttons["Open"].tap()
        XCTAssertTrue(app.buttons["work.P2"].waitForNonExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(project.waitForExistence(timeout: 5))
        project.press(forDuration: 1)
        let signal = app.buttons["Show failed CI"]
        XCTAssertTrue(signal.waitForExistence(timeout: 5))
        signal.tap()
        XCTAssertTrue(app.staticTexts["Failed fixture"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Origin: 1 pull requests")).firstMatch.exists)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Origin snapshot saved")).firstMatch.exists)
        app.staticTexts["Failed fixture"].tap()
        XCTAssertTrue(app.navigationBars["Pull Request"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.descendants(matching: .any)["work.repository"].label.contains("fixture/one"))
        app.buttons["Done"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Project metrics"].waitForExistence(timeout: 5))
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["work.P2"].waitForNonExistence(timeout: 5))
    }
    func testIssueOutcomeSelectionIgnoresSavedGridFilter() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        XCTAssertTrue(project.label.contains("1 pull requests with failed CI"))
        XCTAssertTrue(project.label.contains("1 pull requests with unresolved threads"))
        XCTAssertTrue(project.label.contains("some data unavailable or partial"))
        project.tap()
        XCTAssertTrue(app.buttons["work.I2"].waitForExistence(timeout: 10))
        app.buttons["project.filters"].tap()
        app.buttons["Closed"].tap()
        XCTAssertTrue(app.buttons["work.I2"].waitForNonExistence(timeout: 5))
        app.buttons["project.metrics"].tap()
        let completed = app.buttons["metrics.issues.completed"]
        for _ in 0..<6 where !completed.isHittable { app.swipeUp() }
        XCTAssertTrue(completed.waitForExistence(timeout: 5))
        completed.tap()
        XCTAssertTrue(app.staticTexts["Completed fixture"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Not planned fixture"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["work.I2"].waitForNonExistence(timeout: 5))
    }
    func testAttentionSelectionPreservesOriginAndDistinctUnits() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["work.P2"].waitForExistence(timeout: 10))
        app.buttons["project.filters"].tap()
        app.buttons["Open"].tap()
        XCTAssertTrue(app.buttons["work.P2"].waitForNonExistence(timeout: 5))
        app.buttons["project.metrics"].tap()
        let failed = app.buttons["metrics.failedCI"]
        for _ in 0..<3 where !failed.isHittable { app.swipeUp() }
        XCTAssertTrue(failed.waitForExistence(timeout: 5))
        failed.tap()
        XCTAssertTrue(app.staticTexts["Failed fixture"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Origin: 1 pull requests")).firstMatch.exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let threads = app.buttons["metrics.unresolvedThreads"]
        for _ in 0..<3 where !threads.isHittable { app.swipeUp() }
        XCTAssertTrue(threads.waitForExistence(timeout: 5))
        threads.tap()
        XCTAssertTrue(app.staticTexts["Failed fixture"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Origin: 2 threads")).firstMatch.exists)
        XCTAssertEqual(app.staticTexts.matching(identifier: "Failed fixture").count, 1)
    }

    func testMergedMetricOpensItsOwnSelectionDespiteSavedGridFilter() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        XCTAssertTrue(app.buttons["work.P1"].waitForExistence(timeout: 10))
        app.buttons["project.filters"].tap()
        app.buttons["Merged"].tap()
        XCTAssertTrue(app.buttons["work.P1"].waitForNonExistence(timeout: 5))
        app.buttons["project.metrics"].tap()
        let selection = app.buttons["metrics.merged.selection"]
        for _ in 0..<3 where !selection.isHittable { app.swipeUp() }
        XCTAssertTrue(selection.waitForExistence(timeout: 5))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Merged PR metric"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        selection.tap()
        XCTAssertTrue(app.staticTexts["Merged fixture"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["work.P1"].waitForNonExistence(timeout: 5))
    }

    func testSavedIssueDetailsRemainVisibleOffline() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()
        let cell = app.buttons["work.I1"]
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.tap()
        let assignees = app.descendants(matching: .any)["issue.assignees"]
        for _ in 0..<3 where !assignees.isHittable { app.swipeUp() }
        XCTAssertTrue(assignees.waitForExistence(timeout: 10))
        XCTAssertTrue((assignees.label + String(describing: assignees.value)).contains("alice"))
        let milestone = app.descendants(matching: .any)["issue.milestone"]
        for _ in 0..<3 where !milestone.isHittable { app.swipeUp() }
        XCTAssertTrue(milestone.waitForExistence(timeout: 5))
        XCTAssertTrue((milestone.label + String(describing: milestone.value)).contains("First release"))
        XCTAssertTrue(app.staticTexts["Some assignees are not shown."].exists)
        for _ in 0..<5 where !app.staticTexts["Parent fixture"].isHittable { app.swipeUp() }
        XCTAssertTrue(app.staticTexts["Parent fixture"].waitForExistence(timeout: 10))
        let blocker = app.staticTexts["Blocker fixture"]
        for _ in 0..<4 where !blocker.isHittable { app.swipeUp() }
        XCTAssertTrue(blocker.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Some related issues are not shown."].exists)
        let moreBlockers = app.buttons["issue.loadRelation.blockedBy"]
        for _ in 0..<3 where !moreBlockers.isHittable { app.swipeUp() }
        XCTAssertTrue(moreBlockers.waitForExistence(timeout: 5))
        moreBlockers.tap()
        XCTAssertTrue(app.staticTexts["Could not load more related issues. Showing saved results."].waitForExistence(timeout: 10))
        let closedSubIssues = app.descendants(matching: .any)["issue.closedSubIssues"]
        for _ in 0..<4 where !closedSubIssues.isHittable { app.swipeUp() }
        XCTAssertTrue(closedSubIssues.waitForExistence(timeout: 5))
        XCTAssertTrue((closedSubIssues.label + String(describing: closedSubIssues.value)).contains("0"))
        let linked = app.staticTexts["Linked PR fixture"]
        for _ in 0..<4 where !linked.isHittable { app.swipeUp() }
        XCTAssertTrue(linked.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Cross-reference · closes this issue on merge"].exists)
        XCTAssertTrue(app.staticTexts["Manually linked on GitHub"].exists)
        XCTAssertTrue(app.staticTexts["Some cross-references are not shown."].exists)
        let more = app.buttons["issue.loadMoreLinks"]
        for _ in 0..<3 where !more.isHittable { app.swipeUp() }
        XCTAssertTrue(more.waitForExistence(timeout: 5))
        more.tap()
        XCTAssertTrue(app.staticTexts["Could not load more links. Showing saved results."].waitForExistence(timeout: 10))
        for _ in 0..<6 where !app.staticTexts["Saved synthetic description"].isHittable { app.swipeDown() }
        XCTAssertTrue(app.staticTexts["Saved synthetic description"].waitForExistence(timeout: 10))
        for _ in 0..<8 where !app.staticTexts["Could not update details. Showing saved details."].isHittable { app.swipeUp() }
        XCTAssertTrue(app.staticTexts["Could not update details. Showing saved details."].waitForExistence(timeout: 10))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Offline issue details"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    func testRemoveRepositoryKeepsProjectAndOtherRepository() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()

        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
        project.tap()

        let settings = app.buttons["project.settings"]
        XCTAssertTrue(settings.waitForExistence(timeout: 10))
        settings.tap()

        let first = app.staticTexts["fixture/one"]
        let second = app.staticTexts["fixture/two"]
        XCTAssertTrue(first.waitForExistence(timeout: 10))
        XCTAssertTrue(second.exists)
        second.swipeLeft()
        app.buttons["Remove"].tap()
        app.buttons["Remove from Project"].tap()
        XCTAssertTrue(first.waitForExistence(timeout: 5))
        XCTAssertFalse(second.exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(settings.waitForExistence(timeout: 5))
        settings.tap()
        XCTAssertTrue(first.waitForExistence(timeout: 5))
        XCTAssertFalse(second.exists)
    }
}
