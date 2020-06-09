import Foundation
import UIKit
import SwiftyUserDefaults

class AuthViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityStatusLabel: UILabel!
    
    private let authContentProvider = ContentProvider()
    private var registrationController = StoryboardScene.Registration.registrationViewController.instantiate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onRegistrationComplete),
                                               name: NSNotification.Name(rawValue: "registrationSuccess"), object: registrationController)
        loginButton.addTarget(self, action: #selector(onLoginButtonPressed), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(onRegisterButtonPressed), for: .touchUpInside)
        _ = UINavigationController(rootViewController: registrationController)
    }
    
    @objc func onLoginButtonPressed() {
        self.activityIndicator.isHidden = false
        self.activityStatusLabel.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityStatusLabel.text = "Logging in..."
        
        if let login = loginTextField.text, let password = passwordTextField.text {
            authContentProvider.authenticate(auth: Auth(login: login, passwordHash: password), completionHandler: {
                Defaults[\.username] = login
                Defaults[\.passwordHash] = password
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginSuccess"), object: self)
                    self.activityIndicator.isHidden = true
                    self.activityStatusLabel.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityStatusLabel.text = "Logging in..."
                    self.dismiss(animated: true, completion: nil)
                }
            }, errorHandler: nil)
        }
    }
    
    @objc func onRegisterButtonPressed() {
        self.navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc func onRegistrationComplete() {
        authContentProvider.authenticate(auth: Auth(login: Defaults[\.username]!,
                                                    passwordHash: Defaults[\.passwordHash]!),
        completionHandler: {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginSuccess"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
        }, errorHandler: nil)
    }
}

extension AuthViewController: UITextFieldDelegate {
    
}
