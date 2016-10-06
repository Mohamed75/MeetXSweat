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
    
    
    class func filterEventsByDates(dates: [AnyObject]) -> [Event] {
        
        var returnArray: [Event] = []
        for event in FireBaseDataManager.sharedInstance.events {
            for date in dates {
                let eventDate = event.date.componentsSeparatedByString(" - ")[0]
                
                var selectedDate = MXSCalendarViewController.formatter.stringFromDate(date as! NSDate)
                selectedDate = selectedDate.componentsSeparatedByString(" - ")[0]
                
                if eventDate == selectedDate {
                    returnArray.append(event)
                }
            }
        }
        return returnArray
    }
    
}