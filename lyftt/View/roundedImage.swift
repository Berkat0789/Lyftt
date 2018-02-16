//
//  roundedImage.swift
//  lyftt
//
//  Created by berkat bhatti on 2/16/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import UIKit
@IBDesignable

class roundedImage: UIImageView {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    func updateView() {
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.clipsToBounds = true
    }

}
