import Foundation
import UIKit
import SwiftyUserDefaults

class RegistrationViewController: UIViewController {
    @IBOutlet weak var shortAddressField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordMismatchLabel: UILabel!
    @IBOutlet weak var nicknameTakenLabel: UILabel!
    
    var alertController = UIAlertController()
    private var registrationContentProvider = ContentProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.addTarget(self, action: #selector(performRegistration), for: .touchUpInside)
    }
    
    @objc func performRegistration() {
        guard passwordField.text == retypePasswordField.text else { return }
        
        if let firstName = firstNameField.text, let lastName = lastNameField.text,
            let password = passwordField.text, let shortAddress = shortAddressField.text {
            
            let userDataForRegistration = UserRegistration(firstName: firstName, lastName: lastName,
                                                           bio: nil, shortAddress: shortAddress,passwordHash: password)
                   
            registrationContentProvider.register(user: userDataForRegistration,
            onSuccess: { user in
                Defaults[\.username] = user.shortAddress
                Defaults[\.passwordHash] = password
                Defaults[\.firstName] = user.firstName
                Defaults[\.lastName] = user.lastName ?? String()
                Defaults[\.bio] = user.bio ?? ""
                
                DispatchQueue.main.async {
                    self.proceedToAuthScreen()
                }
            }, onError: { errorCode in
                if errorCode == .conflict {
                    let alert = UIAlertController(title: "Error",
                                                  message: "User name has already been taken!",
                                                  preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func proceedToAuthScreen() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registrationSuccess"), object: self)
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === retypePasswordField {
            if passwordField.text != textField.text {
                passwordMismatchLabel.isHidden = false
            } else {
                passwordMismatchLabel.isHidden = true
            }
        }
    }
}
