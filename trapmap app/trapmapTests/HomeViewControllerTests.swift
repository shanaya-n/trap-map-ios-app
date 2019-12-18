import XCTest
@testable import giphy_sample_ios

class HomeViewControllerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldReturnTheCorrectNumberOfButtons() {
        guard let homeViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "HomeViewController")
                as? HomeViewController else {
            XCTFail()
            return
        }
//        XCTAssertEqual(homeViewController.findEventsButton.value, "Find Events")
//        XCTAssert(homeViewController.modifyEventsButton.exists)
//        XCTAssert(homeViewController.publishEventsButton.exists)
    }

    func testShouldSegueToFindEventsViewControllerWhenFindEventsSelected() {
        guard UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchResultTableViewController")
            is SearchResultTableViewController else {
            XCTFail()
            return
        }
        
        guard let findEventsViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "FindEventsViewController")
                as? FindEventsViewController else {
            XCTFail()
            return
        }

        findEventsViewController.viewDidLoad()
        // Asserts are in the TestApiService implementation, see below.
    }
}
