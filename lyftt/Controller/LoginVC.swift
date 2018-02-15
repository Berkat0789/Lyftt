//
//  LoginVC.swift
//  lyftt
//
//  Created by berkat bhatti on 2/15/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
//Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//--Actions
    
    @IBAction func backedPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailField.text, emailField.text != "" else{return}
        guard let password = passwordField.text, passwordField.text != "" else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                guard let errorCode = AuthErrorCode(rawValue: error!._code) else {return}
                switch errorCode {
                case .invalidEmail:
                    print("email incorrect")
                case .wrongPassword:
                    print("password incorrect")
                default:
                    print("error logging in user")
                }
            }else {
                print("user Logged in")
                //Segue to Home
                return
            }
        }//end auth
    }//end login pressed
    
//--Selectors
    
    

}
