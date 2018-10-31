//
//  EntryViewController.swift
//  Tinder-Clone
//
//  Created by K.K. on 30.10.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import Parse

class EntryViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.isHidden  = true
        infoLabel.text = ""
        
        // keyboard return
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "toUpdate", sender: nil)
        }
    }

    @IBAction func SignUp(_ sender: Any) {
        infoLabel.isHidden  = true
        infoLabel.text = ""
        
        let newUser = PFUser()
        newUser.username = usernameTextField.text   // username rules?
        newUser.password = passwordTextField.text   // password rules?
        newUser.signUpInBackground { (success, error) in
            if error == nil {
                debugPrint("signup ok")
                self.performSegue(withIdentifier: "toUpdate", sender: nil)
            } else { // detailed error processing
                // missing username is handled
                //  missing password is handled
                // account name duplication is handled
                var errorInfo = "signup fail"
                if let nsError = error as NSError? {
                    if let detailedErrorInfo = nsError.userInfo["error"] as? String {
                        errorInfo = detailedErrorInfo
                    }
                }
                debugPrint(errorInfo)
                self.infoLabel.isHidden = false
                self.infoLabel.text = errorInfo
            }
        }
    }
    
    @IBAction func LogIn(_ sender: Any) {
        infoLabel.isHidden  = true
        infoLabel.text = ""
        
        if let username = usernameTextField.text {
            if let password = passwordTextField.text {
                PFUser.logInWithUsername(inBackground: username, password: password) { (pfUser, error) in
                    if error == nil {
                        debugPrint("login ok")
                        self.performSegue(withIdentifier: "toUpdate", sender: nil)
                    } else { // detailed error processing
                        // missing username is handled
                        // wrong username is handled
                        //  missing password is handled
                        //  wrong password is handled
                        var errorInfo = "login fail"
                        if let nsError = error as NSError? {
                            if let detailedErrorInfo = nsError.userInfo["error"] as? String {
                                errorInfo = detailedErrorInfo
                            }
                        }
                        debugPrint(errorInfo)
                        self.infoLabel.isHidden = false
                        self.infoLabel.text = errorInfo
                    }
                }
            }
        }
    }
    
    // text fields keybord management
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        infoLabel.isHidden  = true
        infoLabel.text = ""
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        infoLabel.isHidden  = true
        infoLabel.text = ""
        return true
    }
}




