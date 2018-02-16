//
//  DataService.swift
//  lyftt
//
//  Created by berkat bhatti on 2/15/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import Foundation
import Firebase

enum  accountType {
    case Driver
    case Rider
}
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
    
    
}
