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
        
    }
    
    var conversationRef = FIRDatabaseReference()
    
    func loadData() {
        
        conversations = []
        conversationRef.removeAllObservers()
        conversationRef = FIRDatabase.database().reference().child("conversation-items")
        
        let block: (FIRDataSnapshot) -> Void = { [weak self] (snapshot) in
            
            guard let this = self else {
                return
            }
            let conversation = Conversation(snapshot: snapshot)
            if conversation.isCurrentUserConversation() {
                this.conversations.append(conversation)
            }
        }
        
        conversationRef.observe(.childAdded, with: block)
    }
    
    func getConversationBetweenPersons(_ persons: [String]) -> Conversation? {
        
        for conversation in conversations {
            var existingPersonNumber = 0
            for person in persons {
                
                for aPerson in conversation.persons {
                    if person == aPerson {
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
