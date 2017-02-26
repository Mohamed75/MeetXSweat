//
//  FindDateManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class FindDateManager {
    
    var dates = [AnyObject]()
    
    
    static let sharedInstance = FindDateManager()
    
    
    class func filterEventsByDates(_ dates: [AnyObject]) -> [Event] {
        
        var returnArray: [Event] = []
        for event in FireBaseDataManager.sharedInstance.events {
            for date in dates {
                let eventDate = event.date.components(separatedBy: " - ").first
                
                var selectedDate = MXSCalendarViewController.formatter.string(from: date as! Date)
                selectedDate = selectedDate.components(separatedBy: " - ").first!
                
                if eventDate == selectedDate {
                    returnArray.append(event)
                }
            }
        }
        return returnArray
    }
    
}
