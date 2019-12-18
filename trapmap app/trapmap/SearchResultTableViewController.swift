import UIKit

class SearchResultTableViewController: UITableViewController {
    
    var api: Api = ProcessInfo.processInfo.arguments.contains(TESTING_UI) ?
        MockApiService() : RealApiService()
    
    var failureCallback: ((Error) -> Void)?
    
    var searchParams = SearchParams(location: "")
    var searchResultEvents: [Event] = []
    
    var selectedRow = 0
    
    var eventTitle: String! = ""
    var startTime: String! = ""
    var venueId: String! = ""
    var venueName: String! = ""
    var eventDescription: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        api.api(host: "https://api.eventful.com/")
        // ^^^^^ This should probably go somewhere else eventually but it will do here for now.
        api.searchEvents(with: searchParams, then: display, fail: failureCallback ?? report)
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
        
        if let eventPageViewController = segue.destination as? EventPageViewController {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, y, h:mm a"
            let dateFormatStartTime = dateFormatter.date(from: startTime) ?? Date()
                        
            eventPageViewController.publishParams = PublishParams(title: eventTitle, start_time: dateFormatter.string(from: dateFormatStartTime), venue_id: venueId, venue_name: venueName, description: eventDescription)
        }
    }
    override func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return searchResultEvents.count
    }
    
    override func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = searchResultEvents[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        eventTitle = searchResultEvents[indexPath.row].title
        startTime = searchResultEvents[indexPath.row].start_time
        venueName = searchResultEvents[indexPath.row].venue_name
        eventDescription = searchResultEvents[indexPath.row].description
        self.performSegue(withIdentifier: "showEvent", sender: self)
    }
    
    private func display(searchResult: SearchResult) {
        searchResultEvents = searchResult.events.event
        tableView.reloadData()
    }
    
    private func report(error: Error) {
        let alert = UIAlertController(title: "Network Issue",
                                      message: "Sorry, we seem to have encountered a network problem: \(error.localizedDescription)",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Acknowledge", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
