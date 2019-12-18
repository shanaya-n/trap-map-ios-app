import UIKit

class FindVenuesTableViewController: UITableViewController {
    
    
    var api: Api = ProcessInfo.processInfo.arguments.contains(TESTING_UI) ?
        MockApiService() : RealApiService()
    
    var failureCallback: ((Error) -> Void)?
    
    var publishParams = PublishParams(title: "", start_time: "", venue_id: "", venue_name: "", description: "")
    var searchVenueParams = SearchVenueParams(keywords: "")
    var searchResultVenues: [Venue] = []
    var fromPublish: Bool!
    
    var selectedRow = 0
    
    var venueName: String! = ""
    var venueId: String! = ""
    var cityName: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        api.api(host: "https://api.eventful.com/")
        api.searchVenues(with: searchVenueParams, then: display, fail: failureCallback ?? report)
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
        
        if let venuePageViewController = segue.destination as? VenuePageViewController {
                        
            venuePageViewController.venueParams = VenueParams(venue_name: venueName, id: venueId, city_name: cityName)
            venuePageViewController.publishParams = PublishParams(title: self.publishParams.title, start_time: self.publishParams.start_time, venue_id: venueId, venue_name: venueName, description: self.publishParams.description)
            venuePageViewController.fromPublish = self.fromPublish
        }
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return searchResultVenues.count
    }
    
    override func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = searchResultVenues[indexPath.row].venue_name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        venueName = searchResultVenues[indexPath.row].venue_name
        venueId = searchResultVenues[indexPath.row].id
        cityName = searchResultVenues[indexPath.row].city_name
        
        publishParams = PublishParams(title: publishParams.title, start_time: publishParams.start_time, venue_id: venueId, venue_name: venueName, description: publishParams.description)
        self.performSegue(withIdentifier: "showVenuePage", sender: self)
    }
    
    private func display(searchResult: SearchVenueResult) {
        searchResultVenues = searchResult.data
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
