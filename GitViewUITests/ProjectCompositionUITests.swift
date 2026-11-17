import XCTest

@MainActor final class ProjectCompositionUITests: XCTestCase {
    func testIssueOutcomeSelectionIgnoresSavedGridFilter() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--gitgrid-ui-test-project")
        app.launch()
        let project = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "project.")).firstMatch
        XCTAssertTrue(project.waitForExistence(timeout: 10))
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
