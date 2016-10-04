//
//  MessagesDataManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


class ConversationsDataManager {
    
    
    static let sharedInstance = ConversationsDataManager()
    
    var conversations: [Event] = []
    //var persons: [Person] = []
    
    init() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        eventRef.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            //self.events.append(Event(snapshot: snapshot))
        })
    }
}