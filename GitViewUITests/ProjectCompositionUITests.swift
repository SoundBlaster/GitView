import XCTest

@MainActor final class ProjectCompositionUITests: XCTestCase {
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
