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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 40

    }//--End view did load
    
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
                    let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(LoginVC!, animated: true, completion: nil)
                }catch let error as NSError {
                    print(error)
                }
            }))
            logoutView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(logoutView, animated: true, completion: nil)
        }
        
    }//end logout pressed
    
}
