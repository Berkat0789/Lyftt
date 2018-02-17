//
//  hamburgerVC.swift
//  lyftt
//
//  Created by berkat bhatti on 2/16/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import UIKit
import Firebase

class hamburgerVC: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var driverSwitch: UISwitch!
    @IBOutlet weak var driverModeText: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var usertype: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 40

    }//--End view did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeDriverandRider()
        driverSwitch.isOn = false
        driverSwitch.isHidden = true
        driverModeText.isHidden = true
        
        if Auth.auth().currentUser == nil {
            logoutButton.setTitle("Login or Create Account", for: .normal)
            userEmail.text = ""
            usertype.text = ""
        } else {
            userEmail.text = Auth.auth().currentUser?.email
            logoutButton.setTitle("Logout", for: .normal)
            usertype.text = ""
        }
    }//--End view will appear
    
//Actions
    @IBAction func driverSwitch(_ sender: Any) {
        if driverSwitch.isOn {
            self.driverModeText.text = "Driver Mode on"
            DataService.instance.FB_Reference_Drivers.child((Auth.auth().currentUser?.uid)!).updateChildValues(["isDrivermodeEnabled" : true])
            self.revealViewController().revealToggle(animated: true)
        }else {
            self.driverModeText.text = "Driver Mode Off"
            DataService.instance.FB_Reference_Drivers.child((Auth.auth().currentUser?.uid)!).updateChildValues(["isDrivermodeEnabled" : false])
            self.revealViewController().revealToggle(animated: true)

        }
    }//--end driver swith
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.present(LoginVC!, animated: true, completion: nil)
        } else {
            
            let logoutView = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
            logoutView.addAction(UIAlertAction(title: "logout", style: .destructive, handler: { (LogoutPressed) in
                do {
                    try Auth.auth().signOut()
                    self.logoutButton.setTitle("login/Signup", for: .normal)
                    let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpVC")
                    self.present(signupVC!, animated: true, completion: nil)
                }catch let error as NSError {
                    print(error)
                }
            }))
            logoutView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(logoutView, animated: true, completion: nil)
        }
        
    }//end logout pressed
    
//--View Functions
    func observeDriverandRider() {
    //--Observe Driver
        DataService.instance.FB_Reference_Drivers.observeSingleEvent(of: .value) { (driverSnap) in
           guard let driverSnap = driverSnap.children.allObjects as? [DataSnapshot] else {return}
            
            for driver in driverSnap {
                let switchMode = driver.childSnapshot(forPath: "isDrivermodeEnabled").value as! Bool
                if driver.key == Auth.auth().currentUser?.uid {
                    self.usertype.text = "Driver"
                    self.driverSwitch.isOn = switchMode
                    self.driverSwitch.isHidden = false
                    self.driverModeText.isHidden = false
                }
            }
        }//--End Observe
//observe Rider
        DataService.instance.FB_Reference_Users.observeSingleEvent(of: .value) { (userDataSnap) in
            guard let userDataSnap = userDataSnap.children.allObjects as? [DataSnapshot] else {return}
            
            for rider in userDataSnap {
                if rider.key == Auth.auth().currentUser?.uid {
                    self.usertype.text = "Rider"
                }
            }
        }//end observe rider

    }//end observe driver and Rider
    
    
    
    
}
