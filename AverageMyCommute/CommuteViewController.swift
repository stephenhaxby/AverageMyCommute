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
        case Edit = "Edit"
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
     
        if let commuteToEdit = commute {
            
            addButton.title = buttonTitles.Edit.rawValue
            view(commute: commuteToEdit)
        }
        else {
            
            addButton.title = buttonTitles.Add.rawValue
            viewDefaultCommute()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let uiBarButtonItem = sender as? UIBarButtonItem else {
            return
        }
        
        // check if you selected the save button
        if addButton == uiBarButtonItem {
            
            let commute =
                NSEntityDescription.insertNewObject(forEntityName: "Commute", into: appDelegate.coreDataContext) as! Commute
    
            commute.id = UUID().uuidString
            commute.timeStart = startTimeDatePicker.date as NSDate
            commute.timeEnd = endTimeDatePicker.date as NSDate
            commute.monday = monSegmentControl.selectedSegmentIndex == 0
            commute.tuesday = tueSegmentControl.selectedSegmentIndex == 0
            commute.wednesday = wedSegmentControl.selectedSegmentIndex == 0
            commute.thursday = thurSegmentControl.selectedSegmentIndex == 0
            commute.friday = friSegmentControl.selectedSegmentIndex == 0
            commute.saturday = satSegmentControl.selectedSegmentIndex == 0
            commute.sunday = sunSegmentControl.selectedSegmentIndex == 0
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
        satSegmentControl.selectedSegmentIndex = 0
        sunSegmentControl.selectedSegmentIndex = 0
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
}
