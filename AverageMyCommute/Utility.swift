//
//  Utility.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 30/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import Foundation

class Utility {
    
    static func timeStringFrom(date : Date) -> String {
        
        let calendar = Calendar.current
        
        var dateComponents : DateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.hour = (calendar as NSCalendar).component(NSCalendar.Unit.hour, from: date)
        dateComponents.minute = (calendar as NSCalendar).component(NSCalendar.Unit.minute, from: date)
        
        return timeStringFrom(dateComponents: dateComponents)
    }
    
    static func timeStringFrom(dateComponents : DateComponents) -> String {
        
        let displayHour = (dateComponents.hour! > 12) ? dateComponents.hour!-12 : dateComponents.hour
        let displayMinute = (dateComponents.minute! < 10) ? "0\(dateComponents.minute!)" : String(describing: dateComponents.minute!)
        let displayAMPM = (dateComponents.hour! > 12) ? "PM" : "AM"
        
        return "\(displayHour!):\(displayMinute) \(displayAMPM)"
    }
}
