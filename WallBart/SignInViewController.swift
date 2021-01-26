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
        
        let userName = userNameTextField.text
        let password = userPasswordTextField.text
        
        if (userName?.isEmpty)! || (password?.isEmpty)! {
            print("Username \(String(describing: userName)) or password \(String(describing: password)) is Empty")
            displayMessage(userMessage: "Musisz wpisać dane w oba pola!")
            
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
        
        let url = URL(string: "http://127.0.0.1:5000/userLogin")
        
        guard url != nil else {
            print("Error creating new url object")
            return
        }
        
        var request = URLRequest(url: url!)
        
        let header = ["accept": "string", "content-type": "application/json"]
        
        request.allHTTPHeaderFields = header
        
        let jsonObject = ["Email": userName!, "Pass": password!] as [String: String]
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            
            request.httpBody = requestBody
        } catch {
            print("Error creating data object from the JSON")
        }
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                
                do {
                    _ = String(data: data!, encoding: .utf8)
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: String]
                    print(dictionary)
                } catch {
                    print("Error parsing response data!")
                    print(data ?? <#default value#>)
                }
                
            }
        }
        
        dataTask.resume()
        
        // Connect to our database
        let myUrl = URL(string: "http://127.0.0.1:5000/userLogin") // Route needed
        _ = URLRequest(url: myUrl!) // Make an URL link



        // HTTP Headers
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let postString = ["Email": userName!, "Pass": password!] as [String: String]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Coś poszło nie tak.")
            return
        }

        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in

            self.removeActivityIndicator(activityIndicator: myActivityIndicator)

            if error != nil {
                self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                print("Error: \(String(describing: error))")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                if let parseJSON = json {

                    let accessToken = parseJSON["token"] as? String
                   // let userId = parseJSON["Id"] as? String
                    print("Acces Token: \(String(describing: accessToken))")

                    if (accessToken?.isEmpty)! {
                        self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                        return
                    }

                    DispatchQueue.main.async {
                        let homePage = self.storyboard?.instantiateViewController(identifier: "HomePageViewController") as! HomePageViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }


                } else {
                    self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Nie udało się wykonać tej akcji. Spróbuj ponowne później.ASdASD")
                print("Error: \(String(describing: error))")
                return
            }
        }
        task.resume()
        
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
            print("Register new account button tapped")
            // Constant holds reference to Register view
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:
                  "RegisterUserViewController") as! RegisterUserViewController
            // Show register view in an animated style
            self.present(registerViewController, animated: true)

    }
    
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
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
}
