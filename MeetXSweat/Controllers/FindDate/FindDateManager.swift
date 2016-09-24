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
        for event in DummyData.getEvents() {
            for date in dates {
                var eventDate = event.date?.componentsSeparatedByString(" - ")[0]
                eventDate = eventDate?.stringByReplacingOccurrencesOfString("/", withString: " ")
                
                let selectedDate = MXSCalendarViewController.formatter.stringFromDate(date as! NSDate)
                if eventDate == selectedDate {
                    returnArray.append(event)
                }
            }
        }
        return returnArray
    }
    
}