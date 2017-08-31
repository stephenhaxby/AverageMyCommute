//
//  UserDefaultsManager.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 31/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private static let _commuteSequence = "CommuteSequence"
    
    static var commuteSequence : [Any] {
        
        get {
            return hasArrayValue(_commuteSequence)
                ? UserDefaults.standard.array(forKey: _commuteSequence)!
                : [Any]()
        }

        set {
            UserDefaults.standard.set(newValue, forKey: _commuteSequence)
        }
    }
    
    static func hasArrayValue(_ key: String) -> Bool {

        return UserDefaults.standard.array(forKey: key) != nil
    }
}
