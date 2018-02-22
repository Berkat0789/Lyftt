//
//  destinationAnnotation.swift
//  lyftt
//
//  Created by berkat bhatti on 2/21/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import Foundation
import MapKit

class destinationAnnotaiton: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var userID:  String!
    
    init(coordinate: CLLocationCoordinate2D, userID: String) {
        self.userID = userID
        self.coordinate = coordinate
        super.init()
    }
}
