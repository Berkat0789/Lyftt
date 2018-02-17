//
//  DataService.swift
//  lyftt
//
//  Created by berkat bhatti on 2/15/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import Foundation
import Firebase
import MapKit

let firebase_Ref = Database.database().reference()

class DataService {
    static let instance = DataService()
///--DB Reference
    private(set) public var FB_Reference = firebase_Ref
    private(set) public var FB_Reference_Users = firebase_Ref.child("users")
    private(set) public var FB_Reference_Drivers = firebase_Ref.child("drivers")
///--Add storgage References Below
    
    
///Function to create DB User
    
    func CreateDBUser(uid: String, userData: Dictionary<String, Any>, isDriver: Bool) {
        if isDriver {
            FB_Reference_Drivers.child(uid).updateChildValues(userData)
        } else {
            FB_Reference_Users.child(uid).updateChildValues(userData)
        }
        
    }//end create  user

    //-- Get all udrivers annotation
    
    func getDriversAnnotations(completed: @escaping (_ annotation: MKAnnotation) ->()) {
        var AllDriversAnnotaiton: MKAnnotation!
        
        DataService.instance.FB_Reference_Drivers.observeSingleEvent(of: .value) { (driverSnapShot) in
            guard let driverSnapShot = driverSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for allDrivers in driverSnapShot {
                if allDrivers.hasChild("isDriver") {
                    if allDrivers.hasChild("coordinate") {
                        guard let driverDict = allDrivers.value as? Dictionary <String, Any> else {return}
                        let coordinateArray = driverDict["coordinate"] as! NSArray
                        let driversCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                        let driverAnn = driverAnnotation(coordinate: driversCoordinate, ID: allDrivers.key)
                        AllDriversAnnotaiton = driverAnn
                    }
                }
            }//end loop
            completed(AllDriversAnnotaiton)
        }//end observe
    }//end get drivers annotaitons
    
    
}
