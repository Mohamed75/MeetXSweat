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
    
    
    class func fetchPersons(persons: [String]) {
        
        EventPersons.sharedInstance.persons = []
        
        for personEmail in persons {
            
            for person in FireBaseDataManager.sharedInstance.persons {
                if personEmail == person.email {
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