//
//  LocationCell.swift
//  lyftt
//
//  Created by berkat bhatti on 2/15/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationNAme: UILabel!
    
    func updateCell(locationName: String, LocationAddress: String) {
        self.locationNAme.text = locationName
        self.locationAddress.text = LocationAddress
    }
}
