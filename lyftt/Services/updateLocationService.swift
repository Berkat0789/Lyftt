//
//  updateLocationService.swift
//  lyftt
//
//  Created by berkat bhatti on 2/16/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class UpdateLocationService {
    static let instance = UpdateLocationService()
    
    
///func to track user location in firebase
    func updateUserLocation(forCoordinate coordinate: CLLocationCoordinate2D, locationUpdated: @escaping (_ status: Bool) -> ()) {
        DataService.instance.FB_Reference_Users.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                if user.key == Auth.auth().currentUser?.uid {
                    DataService.instance.FB_Reference_Users.child(user.key).updateChildValues(["coordinate" : [coordinate.latitude, coordinate.longitude]])
                }
            }
            locationUpdated(true)
        }//end db observe
    }//end update user location
    
//--update driver location on Firebase
    func updateDriverLocaton(forCoordinate coordinate: CLLocationCoordinate2D, locationUpdated: @escaping (_ status: Bool) -> ()) {
        DataService.instance.FB_Reference_Drivers.observeSingleEvent(of: .value) { (driverSnap) in
            guard let driverSnap = driverSnap.children.allObjects as? [DataSnapshot] else{return}
            for driver in driverSnap {
                if driver.key == Auth.auth().currentUser?.uid {
                    if driver.childSnapshot(forPath: "isDrivermodeEnabled").value as! Bool == true {
                        DataService.instance.FB_Reference_Drivers.child(driver.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                    }
                }
            }//end loop
            locationUpdated(true)
        }//end observe
    }//end update driver
    
    
    
}//end clsee
