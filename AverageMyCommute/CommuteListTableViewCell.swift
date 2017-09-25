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
                
                mondayLabel.textColor = commuteItem.monday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray
                
                tuesdayLabel.textColor = commuteItem.tuesday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray
                
                wednesdayLabel.textColor = commuteItem.wednesday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray
                
                thursdayLabel.textColor = commuteItem.thursday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray
                
                fridayLabel.textColor = commuteItem.friday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray
                
                saturdayLabel.textColor = commuteItem.saturday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray

                sundayLabel.textColor = commuteItem.sunday ? UIColor(displayP3Red: 0.47796821594238281, green: 1, blue: 1, alpha: 1) : .gray
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
