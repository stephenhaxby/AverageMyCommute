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

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var commuteList : [Commute] = [Commute]()
    
    var appDelegate : AppDelegate {
        get{
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        commuteList = loadCommuteList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        //let isEditing : Bool = self.isEditing
        
        self.isEditing = !self.isEditing
        
        setDoneButtonTitleText()

        //TODO: Ordering for the commute list
        
//        if isEditing {
//            
//            commuteList = loadCommuteList()
//            
//            tableView.reloadData()
//        }
    }
    
    //When moving away from this page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddNewCommuteItemSegue" {
            
            if let commute = sender as? Commute {
                
                // Setup the destination view controllers data
                let commuteController = segue.destination as! CommuteViewController
                commuteController.commute = commute
            }
        }
        else if segue.identifier == "CommuteItemSegue" {
            
            if let tableViewCell = sender as? CommuteListTableViewCell {
             
                // Setup the destination view controllers data
                let workoutController = segue.destination as! WorkoutViewController
                workoutController.commute = tableViewCell.commute
            }
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        
        commuteList = loadCommuteList()
        
        tableView.reloadData()
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
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        
//        return UITableViewCellEditingStyle.delete
//    }
    
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
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//    }
    
    //This method is for the swipe left to delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction : UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: edit)
        
        let deleteAction : UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: delete)
        
        return [deleteAction, editAction]
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
    
    func edit(tableRowAction : UITableViewRowAction, forIndexPath indexPath : IndexPath) {
        
        self.isEditing = false
        
        if((indexPath as NSIndexPath).row < commuteList.count){
            
            let listItem : Commute = commuteList[(indexPath as NSIndexPath).row]
            
            // Manually perform the tableViewCellSegue to go to the edit page
            performSegue(withIdentifier: "AddNewCommuteItemSegue", sender: listItem)
        }
    }
    
    func delete(tableRowAction : UITableViewRowAction, forIndexPath indexPath : IndexPath) {
        
        self.isEditing = false
        
        if((indexPath as NSIndexPath).row < commuteList.count){
            
            let listItem : Commute = commuteList[(indexPath as NSIndexPath).row]
            
            commuteList.remove(at: (indexPath as NSIndexPath).row)
            
            appDelegate.coreDataContext.delete(listItem)
        }
    }
    
    func loadCommuteList() -> [Commute] {

        do {

            return
                try appDelegate.coreDataContext.fetch(NSFetchRequest(entityName: "Commute"))
        }
        catch let error as NSError {

            print("Could not fetch \(error), \(error.userInfo)")
        }

        return [Commute]()
    }
    
    func setDoneButtonTitleText() {
        
        editButton.title = self.isEditing ? "Done" : "Edit"
    }
}

