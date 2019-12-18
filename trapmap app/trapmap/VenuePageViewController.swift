import UIKit

class VenuePageViewController: UIViewController {
    
    var fromPublish: Bool!
    var venueParams = VenueParams(venue_name: "",id: "", city_name: "")
    var publishParams = PublishParams(title: "", start_time: "", venue_id: "", venue_name: "", description: "")
    var searchVenueResult: [Venue] = []
    
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var chooseVenueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        venueNameLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        if fromPublish {
            chooseVenueButton.isEnabled = true
        } else {
            chooseVenueButton.isEnabled = false
        }
        venueNameLabel.text = venueParams.venue_name
        idLabel.text = "Venue ID:\n" + venueParams.id
        cityLabel.text = "City:\n" + venueParams.city_name!
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
        
        if let publishEventFormViewController = segue.destination as? PublishEventFormViewController {
                        
            publishEventFormViewController.publishParams = PublishParams(title: self.publishParams.title, start_time: self.publishParams.start_time, venue_id: venueParams.id, venue_name: venueParams.venue_name, description: self.publishParams.description)
        }
    }
}
