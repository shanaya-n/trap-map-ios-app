import UIKit

class FindVenuesViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.searchBar.accessibilityTraits = UIAccessibilityTraits.searchField
        self.searchBar.isAccessibilityElement = true
        self.searchBar.accessibilityLabel="VenueSearchBar"
        
        
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
    
    func searchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.performSegue(withIdentifier: "findVenues", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let findVenuesTableViewController = segue.destination as? FindVenuesTableViewController {
            findVenuesTableViewController.searchVenueParams = SearchVenueParams(keywords: searchBar.text!)
            findVenuesTableViewController.fromPublish = false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
