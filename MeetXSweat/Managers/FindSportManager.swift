//
//  FindSportManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class FindSportManager {
    
    
    var sports: [AnyObject] = []
    
    
    static let sharedInstance = FindSportManager()
    
    
    class func filterEventsBySports(_ sports: [AnyObject]) -> [Event] {
    
        var returnArray: [Event] = []
        for event in FireBaseDataManager.sharedInstance.events {
            for sport in sports {
                if event.sport == sport as? String || event.sport == (sport as? String)?.uppercased() {
                    returnArray.append(event)
                }
            }
        }
        return returnArray
    }

    class func filterEventsByCurrentUser() -> [Event] {
        
        var returnArray: [Event] = []
        for event in FireBaseDataManager.sharedInstance.events {
            if event.isCurrentPersonAlreadyIn() {
                returnArray.append(event)
            }
        }
        return returnArray
    }
}
