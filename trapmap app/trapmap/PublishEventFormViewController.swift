import UIKit

class PublishEventFormViewController: UIViewController {
    var api: Api = ProcessInfo.processInfo.arguments.contains(TESTING_UI) ?
        MockApiService() : RealApiService()
    
    var failureCallback: ((Error) -> Void)?
    
    var publishParams = PublishParams(title: "", start_time: "", venue_id: "", venue_name: "", description: "")
    
    @IBOutlet weak var publishEventLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextField!
    
    
    var publishEventResult: String = ""
    var publishTime: String! = ""
    var venueParams = VenueParams(venue_name: "",id: "", city_name: "")
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is FindVenuesTableViewController, let sender = unwindSegue.source as? FindVenuesTableViewController  {
            self.publishParams = sender.publishParams
            self.viewDidLoad()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishEventLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        eventNameField.text = publishParams.title
        venueSearchBar.text = publishParams.venue_name
        descriptionField.text = publishParams.description
        
        self.venueSearchBar.accessibilityTraits = UIAccessibilityTraits.searchField
        self.venueSearchBar.isAccessibilityElement = true
        self.venueSearchBar.accessibilityLabel="VenueSearchBar"
        
        self.datePicker.accessibilityTraits = UIAccessibilityTraits.searchField
        self.datePicker.isAccessibilityElement = true
        self.datePicker.accessibilityLabel = "DatePicker"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, y, h:mm a"
        
        let strDate = dateFormatter.string(from: datePicker.date)
        
        if let eventPageViewController = segue.destination as? EventPageViewController {
            
            api.api(host: "https://api.eventful.com/")
            api.publishEvent(with: publishParams, then: display, fail: failureCallback ?? report)
        }
        
        if let findVenuesTableViewController = segue.destination as? FindVenuesTableViewController {
            
            findVenuesTableViewController.publishParams = PublishParams(title: eventNameField.text!, start_time: strDate, venue_id: publishParams.venue_id, venue_name: publishParams.venue_name, description: descriptionField.text!)
            findVenuesTableViewController.searchVenueParams = SearchVenueParams(keywords: venueSearchBar.text!)
            findVenuesTableViewController.fromPublish = true
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func display(publishResult: PublishResult) {
        publishEventResult = publishResult.id
    }
    
    private func report(error: Error) {
        let alert = UIAlertController(title: "Network Issue",
                                      message: "Sorry, we seem to have encountered a network problem: \(error.localizedDescription)",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Acknowledge", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
