//
//  MSXFindManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/4/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import MapKit



/// Possible values of the property findBy.
enum FindBy: Int {
    /// A profile findBy.
    case profile
    /// A sport findBy.
    case sport
    /// A date findBy.
    case date
    /// An arroundMe findBy.
    case arroundMe
}


class MXSFindManager {
    
    
    static let sharedInstance = MXSFindManager()

    var findBy: FindBy
    var dates = [AnyObject]()
    
    var domaine     = ""
    var profession  = ""
    
    var sports: [AnyObject] = []
    
    
    init() {
        findBy = FindBy.sport
    }
    
    
    
    // MARK: --- filtering events by dates ---
    
    class func filterEventsByDates() -> [Event] {
        
        var returnArray: [Event] = []
        for event in FireBaseDataManager.sharedInstance.events {
            for date in sharedInstance.dates {
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
    
    
    // MARK: --- Persons filtering ---
    
    class func filterBy(_ persons: [Person]) -> [Person] {
        
        var returnArray: [Person] = []
        
        for person in persons {
            
            if person.profession == sharedInstance.profession {
                returnArray.append(person)
            }
            if person.domaine == sharedInstance.domaine {
                returnArray.append(person)
            }
        }
        return returnArray
    }
    
    
    // MARK: --- filtering Events by sleceted Sports ---
    
    class func filterEventsBySports() -> [Event] {
        
        var returnArray: [Event] = []
        for event in FireBaseDataManager.sharedInstance.events {
            for sport in sharedInstance.sports {
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
