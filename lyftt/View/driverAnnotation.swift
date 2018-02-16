//
//  driverAnnotation.swift
//  lyftt
//
//  Created by berkat bhatti on 2/16/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import Foundation
import MapKit

class driverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var userID: String!
    
    init(coordinate: CLLocationCoordinate2D, ID: String) {
        self.coordinate = coordinate
        self.userID = ID
        super.init()
    }
//Func to update annotation location with user
    func updateAnnotationCoordinate(annotation: driverAnnotation, coordinate: CLLocationCoordinate2D) {
        var location = self.coordinate
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        UIView.animate(withDuration: 0.2) {
            self.coordinate = location
        }
    }
    
}//end class
