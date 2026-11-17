import XCTest

@MainActor final class ProjectCompositionUITests: XCTestCase {
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
        XCTAssertTrue(app.staticTexts["Saved synthetic description"].waitForExistence(timeout: 10))
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
