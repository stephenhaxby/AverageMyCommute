//
//  TableRowFooterAddNew.swift
//  RemindMe
//
//  Created by Stephen Haxby on 23/02/2016.
//  Copyright © 2016 Stephen Haxby. All rights reserved.
//

import UIKit

// Footer cell class for adding a new reminder with a gesture recognizer to perform a segue to the edit page
class TableRowFooterAddNew : UITableViewCell {
    
    weak var commuteListViewController : CommuteListViewController?
    
    @IBOutlet weak var footerAddNewView: UIView!
    
    override func layoutSubviews() {
        
        if let containerView = footerAddNewView {
            
            //containerView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
            containerView.backgroundColor = UIColor.clear
        }
        
        let selectPress : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableRowFooterAddNew.viewSelected(_:)))
        selectPress.delegate = self
        //selectPress.minimumPressDuration = 1
        selectPress.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(selectPress)
    }
    
    @objc func viewSelected(_ gestureRecognizer:UIGestureRecognizer) {
     
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
         
            if let tableViewController = commuteListViewController {
                
                tableViewController.performSegue(withIdentifier: "AddNewCommuteItemSegue", sender: self)
            }
        }
    }
}
