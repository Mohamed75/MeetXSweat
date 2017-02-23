//
//  Conversation.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController


class Conversation: FireBaseObject {

    var persons: [String] = []
    var messages: [Message] = []
    
    
    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getFullPersons() -> [Person] {
        EventPersons.fetchPersons(persons)
        return EventPersons.sharedInstance.persons
    }
    
    var messagesQuery: FIRDatabaseReference?
    func observeMessages(completionHandler:((messages: [Message])->Void)) {
        
        if let conversationRef = ref {
            
            self.messages = []
            messagesQuery = conversationRef.child("messages")
            
            let block: (FIRDataSnapshot) -> Void = { [weak self] (snapshot) in
                
                guard let this = self else {
                    return
                }
                let message = Message(snapshot: snapshot)
                this.messages.append(message)
                
                completionHandler(messages: this.messages)
            }
            
            messagesQuery!.queryLimitedToLast(100).observeEventType(.ChildAdded, withBlock: block)
        }
    }
    
    func removeObservers() {
        
        if let conversationRef = messagesQuery {
            conversationRef.removeAllObservers()
        }
    }
    
    func addMessage(text: String, senderId: String, controller: ChatViewController?) {
        
        if let conversationRef = ref { // add message to current conversation
            
            let itemRef = conversationRef.child("messages").childByAutoId()
            let message = Message()
            message.text = text
            message.senderId = senderId
            itemRef.setValue(message.asJson())
            
        } else { // create conversation if doesn't exist
            
            let conversationRef = FIRDatabase.database().reference().child("conversation-items")
            let aRef = conversationRef.childByAutoId()
            aRef.setValue(asJson())
            ref = aRef
            addMessage(text, senderId: senderId, controller: nil)
            controller!.viewDidAppear(false)//to restart the observers
        }
    }
    
    
    
    
    
    var userIsTypingRef: FIRDatabaseReference!
    var usersTypingQuery: FIRDatabaseQuery!
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            if userIsTypingRef != nil {
                userIsTypingRef.setValue(newValue)
            }
        }
    }
    
    func observeTyping(senderId: String, completionHandler:((isTyping: Bool)->Void)) {
        
        if let conversationRef = ref {
        
            let typingIndicatorRef = conversationRef.child("typingIndicator")
            userIsTypingRef = typingIndicatorRef.child(senderId)
            userIsTypingRef.onDisconnectRemoveValue()
            usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
            
            let block: (FIRDataSnapshot) -> Void = { [weak self] (snapshot) in
                guard let this = self else {
                    return
                }
                // You're the only typing, don't show the indicator
                if snapshot.childrenCount == 1 && this.isTyping {
                    return
                }
                
                completionHandler(isTyping: snapshot.childrenCount > 0)
            }
            
            usersTypingQuery.observeEventType(.Value, withBlock: block)
        }
    }
    
    func isCurrentUserConversation() -> Bool {
        
        for person in persons {
            if person == User.currentUser.email {
                return true
            }
        }
        return false
    }
    
}