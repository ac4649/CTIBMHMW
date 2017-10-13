//
//  ViewController.swift
//  CT-IBM-Cancer-App
//
//  Created by Adrien Cogny on 10/12/17.
//  Copyright © 2017 Adrien Cogny. All rights reserved.
//

import UIKit
import JTAppleCalendar


class ViewController: UIViewController {
    
    @IBOutlet weak var calView: JTAppleCalendarView!
    
    // color selection
    //text colors
    let selectedDayTextColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let currentMonthTextColor = UIColor(red: 0.0, green: 0.0, blue: 255.0, alpha: 1.0)
    let otherMonthTextColor = UIColor(red: 0.0, green: 100.0, blue: 100.0, alpha: 1.0)
    
    //view colors
    let calendarBackground = UIColor(red:0.0, green:255.0, blue:0.0, alpha:1.0)
    let wellnessGood = UIColor(red:0.0, green:255.0, blue:0.0, alpha:1.0)
    let wellnessMedium = UIColor(red:100.0, green:100.0, blue:0.0, alpha:1.0)
    let wellnessBad = UIColor(red:255.0, green:0.0, blue:0.0, alpha:1.0)
    
    
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //remove the cell-spacing
        calView.minimumLineSpacing = 0
        calView.minimumInteritemSpacing = 0
        calView.backgroundColor = calendarBackground
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("before loop")
        for curCell in calView.visibleCells {
            guard let theCell = curCell as? CustomCell else {return}
            updateWellness(cell: theCell)
        }
        print("ending loop")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWellness(cell: CustomCell?){
        guard let goodCell = cell as? CustomCell else {return}
        print("wellness level = ")
        print(goodCell.wellnessLevel)
        if (goodCell.wellnessLevel == 0){
            goodCell.wellnessLevelView.backgroundColor = wellnessBad
        }
        else if (goodCell.wellnessLevel == 1){
            goodCell.wellnessLevelView.backgroundColor = wellnessMedium
        }
        else if (goodCell.wellnessLevel == 2){
            goodCell.wellnessLevelView.backgroundColor = wellnessGood
        }
        else {
            print("Wellness level not appropriate")
            return
        }
    }
    
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        
        guard let goodCell = view as? CustomCell else {return}
        
        if cellState.isSelected {
            goodCell.dataLabel.textColor = selectedDayTextColor
        }
        else {
            
            if cellState.dateBelongsTo == .thisMonth {
                goodCell.dataLabel.textColor = currentMonthTextColor
                
            }
            else {
                goodCell.dataLabel.textColor = otherMonthTextColor
            }
            
        }
        
    }
    
    func handleCellSelection(view: JTAppleCell?, cellState: CellState){
        
        guard let goodCell = view as? CustomCell else { return }
        
        
        if cellState.isSelected {
            //cell is currently selected so show it
            goodCell.selectedView.isHidden = false
        }
        else {
            //not selected so hide it.
            goodCell.selectedView.isHidden = true
        }
        
    }


}


extension ViewController: JTAppleCalendarViewDataSource {

    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy mm dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = formatter.date(from: "2017 10 01")!
        let endDate = formatter.date(from: "2017 10 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate )
        return parameters
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MyCustomCell", for: indexPath) as! CustomCell
        

        cell.dataLabel.text  = cellState.text
        
        handleCellSelection(view:cell, cellState:cellState)
        handleCellTextColor(view:cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view:cell, cellState:cellState)
        handleCellTextColor(view:cell, cellState: cellState)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view:cell, cellState:cellState)
        handleCellTextColor(view:cell, cellState: cellState)

    }
    
}
