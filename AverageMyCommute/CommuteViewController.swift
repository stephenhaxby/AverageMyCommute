//
//  CommuteViewController.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 10/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import UIKit
import CoreData

class CommuteViewController : UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var monSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var tueSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var wedSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var thurSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var friSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var satSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var sunSegmentControl: UISegmentedControl!
    
    enum buttonTitles : String {
        
        case Add = "Add"
        case Save = "Save"
    }
    
    var appDelegate : AppDelegate {
        
        get
        {
            
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    var commute : Commute?

    override func viewDidLoad() {
        super.viewDidLoad()
     
        startTimeDatePicker.setValue(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), forKey: "textColor")
        endTimeDatePicker.setValue(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), forKey: "textColor")
        
        if let commuteToEdit = commute {
            
            addButton.title = buttonTitles.Save.rawValue
            view(commute: commuteToEdit)
        }
        else {
            
            addButton.title = buttonTitles.Add.rawValue
            viewDefaultCommute()
        }
    }
    
    //When moving away from this page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if sender as? UIBarButtonItem == addButton {
            
            if addButton.title == buttonTitles.Add.rawValue {
            
                add()
            }
            else if addButton.title == buttonTitles.Save.rawValue
                && commute != nil {
                
                save(newCommute : commute!)
            }
        }
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        
//        return true
//    }
    
    func viewDefaultCommute() {
        
        startTimeDatePicker.date = Date()
        endTimeDatePicker.date = Date()
        
        monSegmentControl.selectedSegmentIndex = 0
        tueSegmentControl.selectedSegmentIndex = 0
        wedSegmentControl.selectedSegmentIndex = 0
        thurSegmentControl.selectedSegmentIndex = 0
        friSegmentControl.selectedSegmentIndex = 0
        satSegmentControl.selectedSegmentIndex = 1
        sunSegmentControl.selectedSegmentIndex = 1
    }
    
    func view(commute : Commute?) {
        
        if let editCommute : Commute = commute {
            
            startTimeDatePicker.date = editCommute.timeStart == nil ? Date() : editCommute.timeStart! as Date
            endTimeDatePicker.date = editCommute.timeEnd == nil ? Date() : editCommute.timeEnd! as Date
            
            monSegmentControl.selectedSegmentIndex = editCommute.monday ? 0 : 1
            tueSegmentControl.selectedSegmentIndex = editCommute.tuesday ? 0 : 1
            wedSegmentControl.selectedSegmentIndex = editCommute.wednesday ? 0 : 1
            thurSegmentControl.selectedSegmentIndex = editCommute.thursday ? 0 : 1
            friSegmentControl.selectedSegmentIndex = editCommute.friday ? 0 : 1
            satSegmentControl.selectedSegmentIndex = editCommute.saturday ? 0 : 1
            sunSegmentControl.selectedSegmentIndex = editCommute.sunday ? 0 : 1
        }
        else {
            
            viewDefaultCommute()
        }
    }
    
    func add() {
        
        let commute =
            NSEntityDescription.insertNewObject(forEntityName: "Commute", into: appDelegate.coreDataContext) as! Commute
        
        commute.id = UUID().uuidString
        
        save(newCommute : commute)

    }
    
    func save(newCommute : Commute) {
        
        newCommute.timeStart = startTimeDatePicker.date as NSDate
        newCommute.timeEnd = endTimeDatePicker.date as NSDate
        newCommute.monday = monSegmentControl.selectedSegmentIndex == 0
        newCommute.tuesday = tueSegmentControl.selectedSegmentIndex == 0
        newCommute.wednesday = wedSegmentControl.selectedSegmentIndex == 0
        newCommute.thursday = thurSegmentControl.selectedSegmentIndex == 0
        newCommute.friday = friSegmentControl.selectedSegmentIndex == 0
        newCommute.saturday = satSegmentControl.selectedSegmentIndex == 0
        newCommute.sunday = sunSegmentControl.selectedSegmentIndex == 0
    }
}
