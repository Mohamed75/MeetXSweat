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
    
    init() {
        
        let conversationRef = FIRDatabase.database().reference().child("conversation-items")
        conversationRef.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            let conversation = Conversation(snapshot: snapshot)
            if conversation.isCurrentUserConversation() {
                self.conversations.append(conversation)
            }
        })
    }
    
    func getConversationBetweenPersons(persons: [Person]) -> Conversation? {
        
        for conversation in self.conversations {
            var existingPersonNumber = 0
            for person in persons {
                
                for aPerson in conversation.persons {
                    if person.email == aPerson.email {
                        existingPersonNumber += 1
                    }
                }
            }
            if existingPersonNumber == conversation.persons.count {
                return conversation
            }
        }
        return nil
    }
    
}