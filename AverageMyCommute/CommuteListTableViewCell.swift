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

                timeStartLabel.text = timeStringFrom(date : commuteItem.timeStart! as Date)
                
                timeEndLabel.text = timeStringFrom(date : commuteItem.timeEnd! as Date)
                
                mondayLabel.textColor = commuteItem.monday ? .black : .gray
                
                tuesdayLabel.textColor = commuteItem.tuesday ? .black : .gray
                
                wednesdayLabel.textColor = commuteItem.wednesday ? .black : .gray
                
                thursdayLabel.textColor = commuteItem.thursday ? .black : .gray
                
                fridayLabel.textColor = commuteItem.friday ? .black : .gray
                
                saturdayLabel.textColor = commuteItem.saturday ? .black : .gray

                sundayLabel.textColor = commuteItem.sunday ? .black : .gray
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
    
    func timeStringFrom(date : Date) -> String {
        
        let calendar = Calendar.current
        
        var dateComponents : DateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.hour = (calendar as NSCalendar).component(NSCalendar.Unit.hour, from: date)
        dateComponents.minute = (calendar as NSCalendar).component(NSCalendar.Unit.minute, from: date)
        
        return timeStringFrom(dateComponents: dateComponents)
    }
    
    func timeStringFrom(dateComponents : DateComponents) -> String {
        
        let displayHour = (dateComponents.hour! > 12) ? dateComponents.hour!-12 : dateComponents.hour
        let displayMinute = (dateComponents.minute! < 10) ? "0\(dateComponents.minute!)" : String(describing: dateComponents.minute!)
        let displayAMPM = (dateComponents.hour! > 12) ? "PM" : "AM"
        
        return "\(displayHour!):\(displayMinute) \(displayAMPM)"
    }
}
