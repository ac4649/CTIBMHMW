//
//  TreatmentQuestionTableViewCell.swift
//  CT-IBM-Cancer-App
//
//  Created by Z on 11/17/17.
//  Copyright © 2017 Adrien Cogny. All rights reserved.
//

import UIKit

class TreatmentQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        numberLabel.text = String(Int(stepper.value))
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
