//
//  CustomCell.swift
//  CT-IBM-Cancer-App
//
//  Created by Adrien Cogny on 10/12/17.
//  Copyright © 2017 Adrien Cogny. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var wellnessLevelView: UIView!
    
    var wellnessLevel = 0

    
}
