import XCTest

class FindVenuesViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    let homeViewUITests = HomeViewUITests()
    let publishEventUITests = PublishEventViewUITests()
    
    override func setUp() {
        app.launchArguments.append("UI_TESTING")
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {}
    
    func testShouldDisplayVenueTableViewWhenSearchButtonIsTapped() {
        homeViewUITests.testShouldDisplayFindVenuesControllerWhenModifyEventsIsTapped()
        
        let searchBar = app.searchFields["VenueSearchBar"]
        UIPasteboard.general.string = "The Lyceum"
        
        searchBar.tap()
        sleep(2)
        searchBar.tap()
        app.staticTexts["Paste"].tap()
        app.buttons["VenueSearchButton"].tap()
        
        XCTAssertTrue(app.tables.staticTexts.count > 0)
        XCTAssertTrue(app.tables.staticTexts["The Lyceum"].exists)
    }
    
    func testShouldDisplayVenuePageWhenVenueIsSelected() {
        testShouldDisplayVenueTableViewWhenSearchButtonIsTapped()
        
        app.tables.staticTexts["The Lyceum"].tap()
        
        XCTAssertEqual(app.staticTexts["VenueNameLabel"].label, "The Lyceum")
        XCTAssertEqual(app.staticTexts["IdLabel"].label, "Venue ID:\nV0-001-000402425-6")
        XCTAssertFalse(app.buttons["ChooseVenueButton"].isEnabled)
    }
}

