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
        
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    guard let errorCode = AuthErrorCode(rawValue: error!._code) else {return}
                    switch errorCode {
                    case .invalidEmail:
                        print("invalid Email")
                    case .wrongPassword:
                        print("INcorrect Password")
                    default:
                        print("Register Failed")
                    }
                    
                } else {
                    if self.segmantedView.selectedSegmentIndex == 0 {
                        let userData = ["prividerID": (user?.providerID)!, "email": (user?.email)!] as [String: Any]
                        DataService.instance.CreateDBUser(uid: (user?.uid)!, userData: userData, isDriver: false)
                        let revealvC = self.storyboard?.instantiateViewController(withIdentifier: "revealVC")
                        self.present(revealvC!, animated: true, completion: nil)
                        print("User Registered")
                    } else {
                        let DriverData = ["prividerID" : (user?.providerID)!, "email" :(user?.email)!, "isDrivermodeEnabled": false, "isDriver" :true, "isDriverOnTrip": false] as [String : Any]
                        DataService.instance.CreateDBUser(uid: (user?.uid)!, userData: DriverData, isDriver: true)
                        let homevc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
                        self.present(homevc!, animated: true, completion: nil)
                        print("Driver Registered")
                    }
                    
                }
            })
       
    }//end signupPressed
    
    
}//end controller
