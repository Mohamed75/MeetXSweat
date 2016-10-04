//
//  FindProfileManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class FindProfileManager {
    
    
    var domaine = ""
    var profession = ""
    var experience = ""
    
    
    static let sharedInstance = FindProfileManager()
    
    
    class func filterBy(persons: [Person], filter: String) -> [Person] {
        
        var returnArray: [Person] = []
        
        for person in persons {
            
            if person.profession == filter {
                returnArray.append(person)
            }
        }
        return returnArray
    }
}