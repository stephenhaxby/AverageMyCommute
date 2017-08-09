//
//  ViewController.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 8/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import UIKit
import CoreData

class CommuteListViewController: UITableViewController, UIGestureRecognizerDelegate {

    var commuteList : [Commute] = [Commute]()
    
    var appDelegate : AppDelegate {
        get{
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let commute =
            NSEntityDescription.insertNewObject(forEntityName: "Commute", into: appDelegate.coreDataContext) as! Commute
        
        commute.id = UUID().uuidString
        commute.timeStart = Date() as NSDate
        commute.timeEnd = Date() as NSDate
        commute.monday = true
        commute.tuesday = true
        commute.wednesday = true
        commute.thursday = true
        commute.friday = true

        commuteList.append(commute)
        
//        do {
//            
//            commuteList =
//                (try appDelegate.coreDataContext.fetch(NSFetchRequest(entityName: "Commute")))
//        }
//        catch let error as NSError {
//            
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commuteList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the table cell
        let cell : CommuteListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommuteCell")! as! CommuteListTableViewCell
        
        // Setup a Long Press Gesture for each cell, calling the cellLongPressed method
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CommuteListViewController.cellLongPressed(_:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1
        longPress.numberOfTouchesRequired = 1
        
        cell.addGestureRecognizer(longPress)
        
        // Sets the reminder list item for the cell
        let reminderListItem : Commute = commuteList[(indexPath as NSIndexPath).row]
        cell.commute = reminderListItem
        cell.commuteListViewController = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = commuteList[(sourceIndexPath as NSIndexPath).row]
        
        commuteList.remove(at: (sourceIndexPath as NSIndexPath).row)
        
        commuteList.insert(itemToMove, at: (destinationIndexPath as NSIndexPath).row)
    }
    
//    // This method is for when an item is selected
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        var commute : Commute?
//        
//        commute  = commuteList[(indexPath as NSIndexPath).row]
//        
//        // Manually perform the tableViewCellSegue to go to the edit page
//        performSegue(withIdentifier: "tableViewCellSegue", sender: commute)
//    }
    
    // This method is setting which cells can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //This method is for the swipe left to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        self.isEditing = false
        
        if((indexPath as NSIndexPath).row < commuteList.count){
            
            let listItem : Commute = commuteList[(indexPath as NSIndexPath).row]
            
//            if storageFacade.removeReminder(listItem) {
//                
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.RefreshNotification), object: nil)
//            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        cell.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:0.6)
//    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let  footerRow = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! TableRowFooterAddNew
        
        // Set's up the footer cell so we can perform actions on it
        footerRow.commuteListViewController = self
        
//        // Set the background color of the footer cell
//        footerRow.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:0.8)
        
        return footerRow
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(84)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        // Set's the height for the footer cell
        return CGFloat(64)
    }

    // This method gets called for our Gesture Recognizer
    func cellLongPressed(_ gestureRecognizer:UIGestureRecognizer) {
        
        // If it's the begining of the gesture, set the table to editing mode
        if (gestureRecognizer.state == UIGestureRecognizerState.began){
            
            self.isEditing = true
        }
    }
}

