//
//  CommuteListTableViewCell.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 8/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import UIKit

class CommuteListTableViewCell : UITableViewCell {
    
    // Not sure if this should be weak or not...
    weak var commute : Commute?{
        didSet {
            
            if let commuteItem = commute {

                timeStartLabel.text = Utility.timeStringFrom(date : commuteItem.timeStart! as Date)
                
                timeEndLabel.text = Utility.timeStringFrom(date : commuteItem.timeEnd! as Date)
                
                mondayLabel.textColor = commuteItem.monday ? .black : .red
                
                tuesdayLabel.textColor = commuteItem.tuesday ? .black : .red
                
                wednesdayLabel.textColor = commuteItem.wednesday ? .black : .red
                
                thursdayLabel.textColor = commuteItem.thursday ? .black : .red
                
                fridayLabel.textColor = commuteItem.friday ? .black : .red
                
                saturdayLabel.textColor = commuteItem.saturday ? .black : .red

                sundayLabel.textColor = commuteItem.sunday ? .black : .red
            }
        }
    }
    
    weak var commuteListViewController : CommuteListViewController?
    
    @IBOutlet weak var timeStartLabel: UILabel!
    
    @IBOutlet weak var timeEndLabel: UILabel!
    
    @IBOutlet weak var mondayLabel: UILabel!
    
    @IBOutlet weak var tuesdayLabel: UILabel!
    
    @IBOutlet weak var wednesdayLabel: UILabel!
    
    @IBOutlet weak var thursdayLabel: UILabel!
    
    @IBOutlet weak var fridayLabel: UILabel!
    
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var sundayLabel: UILabel!
}
