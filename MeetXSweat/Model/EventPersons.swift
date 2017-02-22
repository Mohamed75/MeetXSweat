//
//  EventPersons.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/21/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class EventPersons {
    
    static let sharedInstance = EventPersons()
    
    var persons: [Person]!
    var events: [Event]!
    
    
    class func fetchPersons(ppersons: [String]) {
        
        EventPersons.sharedInstance.persons = []
        
        for personEmail in ppersons {
            
            for person in FireBaseDataManager.sharedInstance.persons {
                if personEmail.lowercaseString == person.email.lowercaseString {
                    EventPersons.sharedInstance.persons.append(person)
                }
            }
        }
    }
    
    class func fetchEvents(person: Person) {
        
        EventPersons.sharedInstance.events = []
        
        for event in FireBaseDataManager.sharedInstance.events {
            
            for aPerson in event.persons {
                if person.email == aPerson {
                    EventPersons.sharedInstance.events.append(event)
                }
            }
        }
    }
}