import XCTest
@testable import trapmap

class SearchResultTableViewControllerTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testShouldReturnTheCorrectNumberOfSectionsAndItems() {
        guard let searchResultTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchResultTableViewController")
                as? SearchResultTableViewController else {
            XCTFail()
            return
        }

        searchResultTableViewController.searchResultEvents =  [
            Event(id: "E0-001-130550278-8", title: "Book Club", start_time: "Dec 11, 2019, 7:00 PM", venue_id: "V0-001-000104270-1", venue_name: "5943 Balboa Avenue, Suite #100", description: "Book club meeting for book lovers"),
            
            Event(id: "E0-001-128591811-5", title: "Book Discussion Group", start_time: "Nov 19, 2019, 4:00 PM", venue_id: "V0-001-000264062-5", venue_name: "239 South Kalmia Street", description: "Read the selected book, chat about what you thought, and eat some food inspired by the book. NOV 2019: Orphan Monster Spy by Matt Killeen"),
            
            Event(id: "E0-001-128591884-1", title: "Deathling Book Club", start_time: "Oct 30, 2019, 7:00 PM", venue_id: "V0-001-000402425-6", venue_name: "810 West Valley Parkway", description: "Join us as we kick off our first ever Deathling Book Club")
            ]

        guard let tableView = searchResultTableViewController.tableView else {
            XCTFail()
            return
        }

        XCTAssertEqual(1, searchResultTableViewController.numberOfSections(in: tableView))
        XCTAssertEqual(3, searchResultTableViewController.searchResultEvents.count)
    }

    func testShouldAlwaysAllowItemSelection() {
        guard let searchResultTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchResultTableViewController")
                as? SearchResultTableViewController else {
            XCTFail()
            return
        }

        XCTAssert(searchResultTableViewController.tableView.allowsSelection)
    }

    func testShouldTriggerEventSearchWhenSearchResultTableViewControllerLoads() {
        guard let searchResultTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchResultTableViewController")
                as? SearchResultTableViewController else {
            XCTFail()
            return
        }

        searchResultTableViewController.api = TestApiService()
        searchResultTableViewController.searchParams = SearchParams(location: "San Diego")
        searchResultTableViewController.viewDidLoad()
    }

    func testShouldDisplayAlertWhenAPICallFails() {
        guard let searchResultTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchResultTableViewController")
                as? SearchResultTableViewController else {
            XCTFail()
            return
        }

        var failureCallbackWasCalled = false

        searchResultTableViewController.failureCallback = { _ in failureCallbackWasCalled = true }
        searchResultTableViewController.api = FailingApiService()
        searchResultTableViewController.searchParams = SearchParams(location: "")
        searchResultTableViewController.viewDidLoad()
        XCTAssert(failureCallbackWasCalled)
    }
}

class TestApiService: Api {
    func api(host: String) {
    }

    func searchEvents(with params: SearchParams,
    then: ((SearchResult) -> Void)?,
    fail: ((Error) -> Void)?) {
        XCTAssertEqual(params.location, "San Diego")
    }
    func publishEvent(with params: PublishParams,
    then: ((PublishResult) -> Void)?,
    fail: ((Error) -> Void)?) {
        XCTAssertEqual(params.title, "San Diego")
        XCTAssertEqual(params.start_time, "December 11, 2019, 7:00 PM")
        XCTAssertEqual(params.venue_id, "5943 Balboa Avenue, Suite #100")
        XCTAssertEqual(params.description, "Book club for book club lovers")
    }

    func searchVenues(with params: SearchVenueParams,
    then: ((SearchVenueResult) -> Void)?,
    fail: ((Error) -> Void)?) {
        XCTAssertEqual(params.keywords, "The Forum")
    }
}

class FailingApiService: Api {
    func api(host: String) {
    }

    func searchEvents(with params: SearchParams,
            then: ((SearchResult) -> Void)?,
            fail: ((Error) -> Void)?) {
        if let callback = fail {
            callback(NSError(domain: "test", code: 0, userInfo: nil))
        }
    }
    
    func publishEvent(with params: PublishParams,
            then: ((PublishResult) -> Void)?,
            fail: ((Error) -> Void)?) {
        if let callback = fail {
            callback(NSError(domain: "test", code: 0, userInfo: nil))
        }
    }
    
    func searchVenues(with params: SearchVenueParams,
    then: ((SearchVenueResult) -> Void)?,
    fail: ((Error) -> Void)?) {
        if let callback = fail {
            callback(NSError(domain: "test", code: 0, userInfo: nil))
        }
    }
}
