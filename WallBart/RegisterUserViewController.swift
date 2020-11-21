import UIKit

class RegisterUserViewController: UIViewController {

    // Form fields
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss keyboard while pressing elsewhere on the screen
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
    }
    
    // SignUp button Handler
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("Sign Up Button tapped!")
        
        // Check if all fields aren't empty
        if (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! ||
            (emailAddressTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)!
        {
            // If not display error (alert)
            displayMessage(userMessage: "Należy wpisać dane w każde pole!")
            return
        }
        
        // Check for password equality
        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
        {
            // If not display error (alert)
            displayMessage(userMessage: "Hasła nie są takie same!")
            return
        }
        
        // Create loading spinner
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        
        // Center spinner
        myActivityIndicator.center = view.center
        
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        // Add spinner to view
        view.addSubview(myActivityIndicator)
        
        // Connect to our database
        let myUrl = URL(string: "http://localhost:5000/addUser")
        var request = URLRequest(url: myUrl!)
        
        // HTTP Headers
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Constant holding our data to database as a string
        let postString = [
            "Name": firstNameTextField.text!,
            "Lastname": lastNameTextField.text!,
            "Email": emailAddressTextField.text!,
            "Pass": passwordTextField.text!,
            "Phone_number": "123456789",
            "Accomodation": "Wrocław"
        ] as [String : String]
        
        // Check whether we can JSONify our data (maybe it doesn't exist or sth)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Coś poszło nie tak :(")
            return
        }
        
        // Send HTTP request
        let task = URLSession.shared.dataTask(with: request) {
            
            (data: Data?, response: URLResponse?, error: Error?) in
            
            // Remove our spinner from view
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            // Error shows that data can't be parsed
            if error != nil
            {
                self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                print("error=\(String(describing: error))")
                return
            }
            
            // Convert response into dictionary
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // If dictionary has data
                if let parseJSON = json {
                    
                    // Check whether our user has some data on itself
                    let userId = parseJSON["Id"] as? String
                    print("User ID: \(String(describing: userId!))")
                    
                    if (userId?.isEmpty)! {
                        // Display an error alert
                        self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                        return
                        
                    } else {
                        // If it has data then account creation was successful
                        self.displayMessage(userMessage: "Twoje konto zostało pomyślnie utworzone! Zaloguj się, aby zacząć korzystać z naszej aplikacji!")
                    }
                    
                } else {
                    // Display an error alert
                    self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                }
            } catch {
                // Remove our spinner from view
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                // If converting response to dictionary wasn't successful
                self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                print(error)
            }
        }
        // If everything was OK our func continues
        task.resume()
    }

        
        // Func to remove spinner from the view
        func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
            DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
    
    
    // Cancel Button handler
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel Button tapped!")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to display alerts to user
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
        {
            // Constant hold newly created AlertContorller
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            // Constant hold 'OK' button
            let okAction = UIAlertAction(title: "OK", style: .default)
            {
                // Action after OK button is pressed (dismiss alert)
                (action:UIAlertAction!) in
                print("OK button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
