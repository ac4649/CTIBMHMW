//
//  ViewController.swift
//  CT-IBM-Cancer-App
//
//  Created by Adrien Cogny on 10/12/17.
//  Copyright © 2017 Adrien Cogny. All rights reserved.
//

import UIKit
import JTAppleCalendar


class ViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var calView: JTAppleCalendarView!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var DailyViewMonth: UILabel!
    @IBOutlet weak var DailyViewDate: UILabel!
    var dayViewTitle:UILabel = UILabel()
    var journalStackView: UIStackView = UIStackView()
    var dayStackView: UIStackView = UIStackView()
    
    @IBOutlet weak var dailyDetailsView: UIView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var journalDayViewToggle: UISegmentedControl!
    @IBAction func showDailyDetails(_ sender: UIButton) {
        dailyDetailsView.isHidden = !dailyDetailsView.isHidden
        print("BUTTON IS PRESSED!")
    }
    @IBAction func toggleDayJournal(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            // day view
            dayStackView.isHidden = false
            journalStackView.isHidden = true
        }
        else {
            //journal view
            dayStackView.isHidden = true
            journalStackView.isHidden = false
        }
    }

    let numDataPoints = 100
    //wellnessData is normal but expected as inverted by calendar so we call.reversed on it)
    var wellnessData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0].reversed()
    
    //[7,1,1,4,4,4,7,7,1,1,4,4,4,7,7,1,1,1,4,4,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,2,1,3,4,5,6,6,6,6,7,7,7,1,1,1,2,3,4,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,2,1,3,4,5,6,6,6,6,7,7,7,1,1,1,2].reversed()
    
    var wellnessLevels = [Int](repeating:0, count:100)
    let currDate = Date()
    
    //Fake data
    let journalEntryTitles = ["Hours of Sleep", "Temperature", "Nausea Level", "Other Side Effects"]
    let dayMedication = ["Neupogen", "Zofran"]
    let medDosage = ["9:30 AM", "12:00 PM"]
    
    // color selection
    //text colors
    let selectedDayTextColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let currentMonthTextColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let otherMonthTextColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.25)
    
    //view colors
    let calendarBackground = UIColor(red: 1, green: 1, blue: 1, alpha:1.0)
    let wellnessGood = UIColor(red:0.463, green:0.69, blue:0.25, alpha:1.0)
    let wellnessMedium = UIColor(red:1.0, green:0.79, blue:0.078, alpha:1.0)
    let wellnessBad = UIColor(red:221.0/255.0, green:76.0/255.0, blue:57.0/255.0, alpha:1.0)
    
    let selectedDayBorderColor = UIColor(red:0.0, green:1.0, blue:1.0, alpha:1.0)
    let transparentColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.0)
    
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        prepareData()
        prepareDayTitleLabel()
        prepareDayView()
        prepareJournalView()
        setDailyViewLabels()
        dailyDetailsView.isHidden = true
        scroller.delegate = self
        
        
        if journalDayViewToggle.selectedSegmentIndex == 1{
            // day view
            dayStackView.isHidden = false
            journalStackView.isHidden = true
        } else {
            //journal view
            dayStackView.isHidden = true
            journalStackView.isHidden = false
        }
        
        //remove the cell-spacing
        calView.minimumLineSpacing = 0
        calView.minimumInteritemSpacing = 0
        calView.backgroundColor = calendarBackground

        calView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //load data and update the wellness status for the 42 days on screen
        var curDay = 0
        print(wellnessData)
        print(wellnessLevels)
        for curCell in calView.visibleCells {
            guard let theCell = curCell as? CustomCell else {return}
            theCell.wellnessLevel = wellnessLevels[curDay]
            updateWellness(cell: theCell)
            curDay = curDay + 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareData(){
        var index = 0
        for _ in wellnessData {
            wellnessLevels[index] = Int(arc4random_uniform(3))
//
//            if rn == 0{
//                wellnessLevels[index] = 0
//            }
//            else if rn == 1{
//                wellnessLevels[index] = 1
//            }
//            else {
//                wellnessLevels[index] = 2
//            }
            index = index + 1
        }
        
    }
    
    func updateWellness(cell: CustomCell?){
        guard let goodCell = cell else {return}
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
            goodCell.wellnessLevelView.backgroundColor = wellnessGood
            print("Wellness level not appropriate")
            return
        }
        
        calView.reloadData()
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
//            print("Setting the selectedView properties")
            goodCell.selectedView.isHidden = false
            goodCell.selectedView.layer.borderColor = selectedDayBorderColor.cgColor
            goodCell.selectedView.layer.borderWidth = 5.0
            goodCell.selectedView.layer.backgroundColor = transparentColor.cgColor
            formatter.dateFormat = "EE MMMM dd"
            let tt = formatter.string(from: cellState.date)
            setDayViewTitle(newTitle: tt) //formatter.string(from: cellState.date))
            
        }
        else {
            //not selected so hide it.
            goodCell.selectedView.isHidden = true
        }
        
    }

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    // DAY VIEW FUNCTIONS
    
    func prepareDayView() {
        //create the stack view
        dayStackView.frame = CGRect(x: 0.0, y: dayViewTitle.frame.size.height, width: self.dayView.frame.size.width, height: 200)
        dayStackView.distribution = .equalSpacing
        dayStackView.alignment = .fill
        dayStackView.axis = .horizontal
        dayStackView.backgroundColor = .red
        print("adding constraint")

        // add a meds list
        var mylabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.dayStackView.frame.size.width, height: 30))
        mylabel.center = CGPoint(x:self.dayView.frame.size.width/2, y:50/2)
        mylabel.textAlignment = .center
        mylabel.text = "MEDICATIONS"
        mylabel.font = UIFont(name: "Roboto", size: 18)
        mylabel.attributedText = NSAttributedString(string: mylabel.text!, attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        mylabel.backgroundColor = .white
        
        dayStackView.addSubview(mylabel)
        
        var i:Float = 1
        var dosageIndex = 0
        for curText in dayMedication{
            var curVertStack = UIStackView(frame: CGRect(x: 0, y: (CGFloat(50/2 + 30*i)), width: self.dayStackView.frame.size.width, height: 30))
            curVertStack.distribution = .equalSpacing
            curVertStack.alignment = .fill
            curVertStack.axis = .vertical
            
            var nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.dayStackView.frame.size.width/2, height: 30))
            nameLabel.center = CGPoint(x:3*self.dayView.frame.size.width/4, y:0.0)
            nameLabel.textAlignment = .left
            nameLabel.text = curText
            nameLabel.font = UIFont(name: "Roboto", size: 18)
            nameLabel.backgroundColor = .white
            
            curVertStack.addSubview(nameLabel)
            
            var dosageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.dayStackView.frame.size.width/2, height: 30))
            dosageLabel.center = CGPoint(x:self.dayView.frame.size.width/4 - 20, y:0.0)
            dosageLabel.textAlignment = .right
            dosageLabel.text = medDosage[dosageIndex]
            dosageLabel.font = UIFont(name: "Roboto", size: 18)
            dosageLabel.backgroundColor = .white
            
            curVertStack.addSubview(dosageLabel)

            dayStackView.addSubview(curVertStack)
            i = i+1
            dosageIndex = dosageIndex + 1
        }
        self.dayView.addSubview(dayStackView)
        
    }
    
    func setDayViewTitle(newTitle: String) {
        dayViewTitle.text = newTitle
        dayViewTitle.font = UIFont(name: "Roboto", size: 24)
    }
    
    func setDailyViewLabels() {
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        formatter.dateFormat = "MMM"
        let thisMonth = formatter.string(from: currDate as Date).uppercased()
        
        formatter.dateFormat = "dd"
        let todaysDate = formatter.string(from: currDate as Date)

        DailyViewDate.text = todaysDate
        DailyViewMonth.text = thisMonth
    }
    
    func prepareDayTitleLabel() {
        dayViewTitle.textAlignment = .center
        dayViewTitle.frame = CGRect(x: 0.0, y: 0.0, width: self.dayView.frame.size.width, height: 20)
        print(dayViewTitle)
        //add the title to the detail view
        dayView.addSubview(dayViewTitle)
    }
    
    func prepareJournalView() {
        //create the stack view
        journalStackView.frame = CGRect(x: 0.0, y: dayViewTitle.frame.size.height, width: self.dayView.frame.size.width, height: 200)
        journalStackView.distribution = .equalSpacing
        journalStackView.alignment = .fill
        journalStackView.axis = .horizontal
        journalStackView.backgroundColor = .red
        
        // add the Journal Title
        var mylabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.journalStackView.frame.size.width, height: 30))
        mylabel.center = CGPoint(x:self.dayView.frame.size.width/2, y:50/2)
        mylabel.textAlignment = .center
        mylabel.text = "JOURNAL"
        mylabel.attributedText = NSAttributedString(string: mylabel.text!, attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        mylabel.backgroundColor = .white
        journalStackView.addSubview(mylabel)
        
        
        //add text fields
        
//        var myTextView = UITextView(frame: CGRect(x: 0, y: 30, width: self.dayStackView.frame.size.width, height: 150))
//        myTextView.delegate = self
//        journalStackView.addSubview(myTextView)
        // journalEntryTitles
        
        
        var i:Float = 1
        
        for curText in journalEntryTitles{
            var journalVertStack = UIStackView(frame: CGRect(x: 0, y: (CGFloat(50/2 + 30*i)), width: self.dayStackView.frame.size.width, height: 30))
            
            var newLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.dayStackView.frame.size.width/2 - 20, height: 30))
            newLabel.center = CGPoint(x: self.dayView.frame.size.width/4, y:0)
            newLabel.textAlignment = .right
            newLabel.text = curText
            newLabel.backgroundColor = .white
            
            
            journalVertStack.addSubview(newLabel)
            
            var newTextField = UITextView(frame: CGRect(x: 0, y: 0, width: self.dayStackView.frame.size.width/2, height: 30))
            newTextField.center = CGPoint(x: 3*self.dayView.frame.size.width/4, y:0)
            newTextField.textAlignment = .left
            newTextField.text = "Enter Text Here"
            newTextField.backgroundColor = .white
            journalVertStack.addSubview(newTextField)

            
            journalStackView.addSubview(journalVertStack)

            i = i+1
        }
        
        
        
        self.dayView.addSubview(journalStackView)
        
        
    }
}


extension ViewController: JTAppleCalendarViewDataSource {

    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
//        let ds = formatter.string(from: currDate as Date)
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 30")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate )
        return parameters
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MyCustomCell", for: indexPath) as! CustomCell
        

        cell.dataLabel.text  = cellState.text
//        print(cellState.date)
//        print(cell.wellnessLevel)
        
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
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}
