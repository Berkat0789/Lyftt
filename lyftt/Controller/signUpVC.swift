//
//  signUpVC.swift
//  lyftt
//
//  Created by berkat bhatti on 2/15/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import UIKit
import Firebase

class signUpVC: UIViewController {
//--Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var segmantedView: UISegmentedControl!
    
//Var and Arrays    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
//--Actions
    @IBAction func signUpPressed(_ sender: Any) {
        guard let email = emailField.text, emailField.text != "" else {return}
        guard let password = passwordField.text, passwordField.text != "" else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                guard let errorCode = AuthErrorCode(rawValue: error!._code) else {return}
                switch errorCode {
                case .appNotAuthorized:
                    print("app not Authorized")
                case .emailAlreadyInUse:
                    print("email already in use")
                default:
                    print("Error Registering User")
                }// end switch
                
            } else { //error is nil
                
                if self.segmantedView.selectedSegmentIndex == 0 {
                    let userData = ["providerID" : (user?.providerID)!, "email": email]
                    DataService.instance.CreateDBUser(uid: (user?.uid)!, userData: userData, isDriver: false)
                } else {
                    let DriverData = ["providerID" : (user?.providerID)!, "email": email, "isDriverModeEnabled" : false, "userisDriver": true, "userOnTrip": false] as [String: Any]
                    DataService.instance.CreateDBUser(uid: (user?.uid)!, userData: DriverData, isDriver: true)
                }
                
            }
            print("User Registered")
        }//--End Auth
        
       
    }//end signupPressed
    
    
}//end controller
