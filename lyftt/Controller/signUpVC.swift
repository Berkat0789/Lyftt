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
    @IBOutlet weak var errorMessage: UILabel!
    //Var and Arrays
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true

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
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "Invalid Email Address"
                    case .weakPassword:
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "Weak Password"
                    default:
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "Invalid login credentials"
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
                        let revealvC = self.storyboard?.instantiateViewController(withIdentifier: "revealVC")
                        self.present(revealvC!, animated: true, completion: nil)
                        print("Driver Registered")
                    }
                    
                }
            })
       
    }//end signupPressed
    
    
}//end controller
