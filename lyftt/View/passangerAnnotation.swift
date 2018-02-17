//
//  passangerAnnotation.swift
//  lyftt
//
//  Created by berkat bhatti on 2/17/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import Foundation
import MapKit

class passangerAnnotaiton: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var userID: String!
    
    init(Coordinate: CLLocationCoordinate2D, userID: String ) {
        self.coordinate = Coordinate
        self.userID = userID
        super.init()
    }
}//end Class 
