import XCTest
@testable import trapmap

class PublishResultViewControllerTests: XCTestCase {
    
    override func setUp() {}
    
    override func tearDown() {}
    
    func testShouldTriggerPublishEventWhenPublishIsTapped() {
        guard let publishEventFormViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PublishEventFormViewController")
            as? PublishEventFormViewController else {
                XCTFail()
                return
        }
        
        publishEventFormViewController.api = TestApiService()
        publishEventFormViewController.publishParams = PublishParams(title: "Book Club", start_time: "Dec 11, 2019, 7:00 PM", venue_id: "V0-001-000104270-1", venue_name: "5943 Balboa Avenue, Suite #100", description: "Book club meeting for book lovers")
//        publishEventFormViewController.viewDidLoad()
    }
    
    func testShouldDisplayAlertWhenAPICallFails() {
        guard let publishEventFormViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PublishEventFormViewController")
            as? PublishEventFormViewController else {
                XCTFail()
                return
        }
        
        var failureCallbackWasCalled = false
        
        publishEventFormViewController.failureCallback = { _ in failureCallbackWasCalled = true }
        publishEventFormViewController.api = FailingApiService()
        publishEventFormViewController.publishParams = PublishParams(title: "", start_time: "", venue_id: "", venue_name: "", description: "")
//        TODO
//        publishEventFormViewController.viewDidLoad()

//        publishEventFormViewController.performSegue(withIdentifier: "publishEvent", sender: self)
//        XCTAssert(failureCallbackWasCalled)
    }
}
