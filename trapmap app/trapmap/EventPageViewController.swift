import UIKit

class EventPageViewController: UIViewController {
    
    var publishParams = PublishParams(title: "", start_time: "", venue_id: "", venue_name: "", description: "")
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventName.widthAnchor.constraint(equalToConstant: 400).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        eventName.text = publishParams.title
        startTime.text = "Time:\n" + publishParams.start_time!
        location.text = "Location:\n" + publishParams.venue_name!
        
        if publishParams.description == nil {
            eventDescription.text = "No description for this event"
        }
        else {
            eventDescription.text = "Description:\n" + publishParams.description!
        }
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
}
