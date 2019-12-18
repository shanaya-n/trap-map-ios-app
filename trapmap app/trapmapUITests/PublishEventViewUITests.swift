import XCTest

class PublishEventViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    let homeViewUITests = HomeViewUITests()
    
    override func setUp() {
        app.launchArguments.append("UI_TESTING")
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {}
    
    func testShouldDisplayFindVenuesTableWhenSearchVenuesButtonIsTapped() {
        homeViewUITests.testShouldDisplayPublishEventControllerWhenPublishEventsIsTapped()
        
        UIPasteboard.general.string = "The Lyceum"
        
        app.searchFields["VenueSearchBar"].tap()
        sleep(2)
        app.searchFields["VenueSearchBar"].tap()
        app.staticTexts["Paste"].tap()
        app.buttons["VenueSearchButton"].tap()
        
        XCTAssertTrue(app.tables.staticTexts.count > 0)
        XCTAssertTrue(app.tables.staticTexts["The Lyceum"].exists)
    }
    
    func testShouldDisplayVenuePageWhenVenueIsSelected() {
        testShouldDisplayFindVenuesTableWhenSearchVenuesButtonIsTapped()
        
        app.tables.staticTexts["The Lyceum"].tap()
        
        XCTAssertEqual(app.staticTexts["VenueNameLabel"].label, "The Lyceum")
        XCTAssertEqual(app.staticTexts["IdLabel"].label, "Venue ID:\nV0-001-000402425-6")
        XCTAssertTrue(app.buttons["ChooseVenueButton"].isEnabled)
    }
    
    func testShouldPopulateVenueSearchBarWithSelectedVenueWhenChooseVenueButtonIsTapped() {
        testShouldDisplayVenuePageWhenVenueIsSelected()
        
        app.buttons["ChooseVenueButton"].tap()
        
        app.searchFields["VenueSearchBar"].tap()
        sleep(2)
        app.searchFields["VenueSearchBar"].tap()
        app.staticTexts["Select All"].tap()
        app.staticTexts["Copy"].tap()
        XCTAssertEqual(UIPasteboard.general.string, "The Lyceum")
    }
    
    func testShouldKeepPublishViewTextFieldsPopulatedAfterChoosingVenue() {
        homeViewUITests.testShouldDisplayPublishEventControllerWhenPublishEventsIsTapped()
        let eventNameField = app.textFields["EventNameField"]
        eventNameField.tap()
        eventNameField.typeText("Concert")
        app.staticTexts["PublishEventLabel"].tap()
        
        let descriptionField = app.textFields["DescriptionField"]
        descriptionField.tap()
        descriptionField.typeText("An awesome concert!")
        app.staticTexts["PublishEventLabel"].tap()
        
        UIPasteboard.general.string = "The Lyceum"
        
        app.searchFields["VenueSearchBar"].tap()
        sleep(2)
        app.searchFields["VenueSearchBar"].tap()
        app.staticTexts["Paste"].tap()
        app.buttons["VenueSearchButton"].tap()
        
        app.tables.staticTexts["The Lyceum"].tap()
        
        app.buttons["ChooseVenueButton"].tap()
        
        XCTAssertEqual(eventNameField.value as! String, "Concert")
        XCTAssertEqual(descriptionField.value as! String, "An awesome concert!")
    }
    
    func testShouldDisplayEventPageWhenPublishEventButtonIsTapped() {
        testShouldKeepPublishViewTextFieldsPopulatedAfterChoosingVenue()
        
        let datePicker = app.datePickers["DatePicker"]
        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Dec 1")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "6")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "00")
        datePicker.pickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: "PM")
        
        app.buttons["PublishButton"].tap()
        
        XCTAssertEqual(app.staticTexts["EventNameLabel"].label, "Concert")
        XCTAssertEqual(app.staticTexts["LocationLabel"].label, "Location:\nThe Lyceum")
        XCTAssertEqual(app.staticTexts["StartTimeLabel"].label, "Time:\nDec 01, 2019, 6:00 PM")
        XCTAssertEqual(app.staticTexts["DescriptionLabel"].label, "Description:\nAn awesome concert!")
    }
}
