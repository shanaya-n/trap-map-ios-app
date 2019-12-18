import XCTest

class HomeViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        app.launchArguments.append("UI_TESTING")
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {}
    
    func testHomeViewShouldContainButtons() {
        XCTAssertTrue(app.buttons["FindEventsButton"].exists)
        XCTAssertTrue(app.buttons["PublishEventsButton"].exists)
        XCTAssertTrue(app.buttons["FindVenuesButton"].exists)
    }
    
    func testShouldDisplayFindEventsControllerWhenFindEventsIsTapped() {
        let findEventsButton = app.buttons["FindEventsButton"]
        findEventsButton.tap()
        
        XCTAssertTrue(app.staticTexts["Find Events"].exists)
    }
    
    func testShouldDisplayPublishEventControllerWhenPublishEventsIsTapped() {
        app.buttons["PublishEventsButton"].tap()
        
        XCTAssertTrue(app.staticTexts["PublishEventLabel"].exists)
        XCTAssertTrue(app.textFields["EventNameField"].exists)
        XCTAssertTrue(app.searchFields["VenueSearchBar"].exists)
        XCTAssertTrue(app.buttons["VenueSearchButton"].exists)
        XCTAssertTrue(app.datePickers["DatePicker"].exists)
        XCTAssertTrue(app.textFields["DescriptionField"].exists)
        XCTAssertTrue(app.buttons["PublishButton"].exists)
    }
    
    func testShouldDisplayFindVenuesControllerWhenModifyEventsIsTapped() {
        app.buttons["FindVenuesButton"].tap()
        
        XCTAssertTrue(app.staticTexts["FindVenuesLabel"].exists)
        XCTAssertTrue(app.searchFields["VenueSearchBar"].exists)
        XCTAssertTrue(app.buttons["VenueSearchButton"].exists)
    }
}
