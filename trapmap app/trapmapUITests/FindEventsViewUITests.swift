import XCTest

class FindEventsViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    let homeViewUITests = HomeViewUITests()
    
    override func setUp() {
        app.launchArguments.append("UI_TESTING")
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {}
    
    func testShouldDisplayTableViewWhenSearchBarSearchButtonIsTapped() {
        homeViewUITests.testShouldDisplayFindEventsControllerWhenFindEventsIsTapped()
        
        if app.staticTexts["Allow Once"].exists {
            app.staticTexts["Allow Once"].tap()
        }
        
        let searchBar = app.searchFields["SearchBar"]
        UIPasteboard.general.string = "Book Club"

        searchBar.tap()
        sleep(2)
        searchBar.tap()
        app.staticTexts["Paste"].tap()
        app.buttons["SearchBarSearchButton"].tap()
        
        XCTAssertTrue(app.tables.staticTexts.count > 0)
        XCTAssertTrue(app.tables.staticTexts["Book Club"].exists)
    }
    
    func testShouldSearchByLocationWhenMapSearchButtonIsTapped(){
        homeViewUITests.testShouldDisplayFindEventsControllerWhenFindEventsIsTapped()
        
        //        BROKEN
        //        let mapView = app.maps["MapView"]
        //        mapView.tap()
        if app.staticTexts["Allow Once"].exists {
            app.staticTexts["Allow Once"].tap()
        }
        
        app.buttons["MapSearchButton"].tap()
        
        XCTAssertTrue(app.tables.staticTexts.count > 0)
    }
    
    func testShouldDisplayEventPageWhenEventIsSelected() {
        testShouldDisplayTableViewWhenSearchBarSearchButtonIsTapped()
        
        app.tables.staticTexts["Book Club"].tap()
        
        XCTAssertEqual(app.staticTexts["EventNameLabel"].label, "Book Club")
        XCTAssertEqual(app.staticTexts["LocationLabel"].label, "Location:\n5943 Balboa Avenue, Suite #100")
        XCTAssertEqual(app.staticTexts["StartTimeLabel"].label, "Time:\nDec 11, 2019, 7:00 PM")
        XCTAssertEqual(app.staticTexts["DescriptionLabel"].label, "Description:\nBook club meeting for book lovers")
    }
}
