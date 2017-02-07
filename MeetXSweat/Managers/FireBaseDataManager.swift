//
//  FireBaseDataManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


class FireBaseDataManager {
    
    
    static let sharedInstance = FireBaseDataManager()
    
    var events: [Event] = []
    var persons: [Person] = []
    
    init() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        eventRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            this.events.append(Event(snapshot: snapshot))
        })
        
        let personRef = FIRDatabase.database().reference().child("person-items")
        personRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            this.persons.append(Person(snapshot: snapshot))
        })
    }
}


