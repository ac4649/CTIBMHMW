//
//  WizardViewController.swift
//  CT-IBM-Cancer-App
//
//  Created by Z on 11/16/17.
//  Copyright © 2017 Adrien Cogny. All rights reserved.
//

import UIKit

enum Treatment : String {
    case Surgery = "Surgery"
    case Chemotherapy = "Chemotherapy"
    case RadiationTherapy = "Radiation Therapy"
}

class WizardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var treatmentPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentTreatment = Treatment.Surgery
    var pickerData: [Treatment] = [Treatment]()
    var tableDataForTreatment: [Treatment: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        treatmentPicker.dataSource = self
        treatmentPicker.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pickerData = [Treatment.Surgery, Treatment.Chemotherapy, Treatment.RadiationTherapy]
        
        tableDataForTreatment[Treatment.Surgery] = ["How many days since the surgery?", "How many days did you spend in the hospital?", "How many hours do you spend in bed each day?"]
        tableDataForTreatment[Treatment.Chemotherapy] = ["How many weeks per therapy round?", "How many rounds?", "How many weeks do you rest between rounds?", "How many days since you began your cycle?", "How many meals do you have each day?", "How many hours do you rest after a session?"]
        tableDataForTreatment[Treatment.RadiationTherapy] = ["How many days per week do you get therapy?", "How long do you usually stay in bed after radiation?", "How many hours of sleep do you usually get?"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected" + pickerData[row].rawValue)
        
        currentTreatment = pickerData[row]
        tableView.reloadData()
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableDataForTreatment[currentTreatment]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TreatmentCellIdentifier", for: indexPath) as? TreatmentQuestionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.questionLabel.text = tableDataForTreatment[currentTreatment]![indexPath.row]

        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}