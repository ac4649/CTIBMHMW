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

    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MyCustomCell", for: indexPath) as! CustomCell
        
        cell.dataLabel.text  = cellState.text
        
        return cell
    }
    
    
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
