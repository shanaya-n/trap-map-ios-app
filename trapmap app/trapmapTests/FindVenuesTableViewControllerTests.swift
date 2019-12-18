import XCTest
@testable import trapmap

class FindVenueTableViewControllerTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testShouldReturnTheCorrectNumberOfSectionsAndItems() {
        guard let findVenuesTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "FindVenuesTableViewController")
                as? FindVenuesTableViewController else {
            XCTFail()
            return
        }

        findVenuesTableViewController.searchResultVenues =  [
        Venue(venue_name: "Mysterious Galaxy Books", id: "V0-001-000104270-1", city_name: "San Diego"),
        Venue(venue_name: "Escondido Public Library", id: "V0-001-000264062-5", city_name: "San Diego"),
        Venue(venue_name: "The Lyceum Stage", id: "V0-001-000402425-6", city_name: "San Diego")]

        guard let tableView = findVenuesTableViewController.tableView else {
            XCTFail()
            return
        }

        XCTAssertEqual(1, findVenuesTableViewController.numberOfSections(in: tableView))
        XCTAssertEqual(3, findVenuesTableViewController.searchResultVenues.count)
    }

    func testShouldAlwaysAllowItemSelection() {
        guard let findVenuesTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "FindVenuesTableViewController")
                as? FindVenuesTableViewController else {
            XCTFail()
            return
        }

        XCTAssert(findVenuesTableViewController.tableView.allowsSelection)
    }

    func testShouldTriggerVenueSearchWhenSearchVenueResultTableViewControllerLoads() {
        guard let findVenuesTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "FindVenuesTableViewController")
                as? FindVenuesTableViewController else {
            XCTFail()
            return
        }

        findVenuesTableViewController.api = TestApiService()
        findVenuesTableViewController.searchVenueParams = SearchVenueParams(keywords: "The Lyceum")
//        TODO: BROKEN
//        findVenuesTableViewController.viewDidLoad()
    }

    func testShouldDisplayAlertWhenAPICallFails() {
        guard let findVenuesTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "FindVenuesTableViewController")
                as? FindVenuesTableViewController else {
            XCTFail()
            return
        }

        var failureCallbackWasCalled = false

        findVenuesTableViewController.failureCallback = { _ in failureCallbackWasCalled = true }
        findVenuesTableViewController.api = FailingApiService()
        findVenuesTableViewController.searchVenueParams = SearchVenueParams(keywords: "")
        findVenuesTableViewController.viewDidLoad()
        XCTAssert(failureCallbackWasCalled)
    }
}
