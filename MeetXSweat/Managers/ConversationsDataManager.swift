//
//  MessagesDataManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController


class ConversationsDataManager {
    
    
    static let sharedInstance = ConversationsDataManager()
    
    var conversations: [Conversation] = []
    //var persons: [Person] = []
    
    init() {
        
        let conversationRef = FIRDatabase.database().reference().child("conversation-items")
        conversationRef.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.conversations.append(Conversation(snapshot: snapshot))
        })
    }
    /*
    let rootRef = FIRDatabase.database().reference().child("messages")
    var messageRef: FIRDatabaseReference!
    */
}