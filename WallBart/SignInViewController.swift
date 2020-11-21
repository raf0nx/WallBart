import UIKit

class SignInViewController: UIViewController {
    // Login form's fields
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dismiss keyboard while pressing elsewhere on the screen
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func singInButtonTapped(_ sender: Any) {
        print("Sing in button tapped!")
        
        // Dummy email & password compare
        if userNameTextField.text == "test" && userPasswordTextField.text == "test" {
            // Constant holds reference to Home Page view
            let homePageViewController = self.storyboard?.instantiateViewController(withIdentifier:
                  "HomePageViewController") as! HomePageViewController
            // Show Home Page view in an animated style
            self.present(homePageViewController, animated: true)
        }
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
            print("Register new account button tapped")
            // Constant holds reference to Register view
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:
                  "RegisterUserViewController") as! RegisterUserViewController
            // Show register view in an animated style
            self.present(registerViewController, animated: true)

    }
}
