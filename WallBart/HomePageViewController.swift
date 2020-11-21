import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        print("Load Member Button tapped!")
    }
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        print("Sign Out Button tapped!")
        
        // Return to previous view
        self.dismiss(animated: true, completion: nil)
    }
}
