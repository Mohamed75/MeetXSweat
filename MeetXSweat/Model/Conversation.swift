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


class Conversation: MXSObject {

    var persons: [Person]?
    var messages = [Message]()
    var ref: FIRDatabaseReference?
    
    override init() {
        
        ref = nil
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        
        super.init(snapshot: snapshot)
        ref = snapshot.ref
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func observeMessages(completionHandler:((messages: [Message])->Void)) {
        
        if let conversationRef = self.ref {
            
            let messagesQuery = conversationRef.child("messages").queryLimitedToLast(25)
            messagesQuery.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                
                self.messages.append(Message(snapshot: snapshot))
                completionHandler(messages: self.messages)
            })
        }
    }
    
    func addMessage(text: String, senderId: String, controller: ChatViewController?) {
        
        if let conversationRef = self.ref {
            
            let itemRef = conversationRef.child("messages").childByAutoId()
            let message = Message()
            message.text = text
            message.senderId = senderId
            itemRef.setValue(message.asJson())
            
        } else {
            
            let conversationRef = FIRDatabase.database().reference().child("conversation-items")
            let aRef = conversationRef.childByAutoId()
            aRef.setValue(self.asJson())
            self.ref = aRef
            [self.addMessage(text, senderId: senderId, controller: nil)];
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
        
        if let conversationRef = self.ref {
        
            let typingIndicatorRef = conversationRef.child("typingIndicator")
            userIsTypingRef = typingIndicatorRef.child(senderId)
            userIsTypingRef.onDisconnectRemoveValue()
            usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
            
            usersTypingQuery.observeEventType(.Value, withBlock: { (data) in
                
                // You're the only typing, don't show the indicator
                if data.childrenCount == 1 && self.isTyping {
                    return
                }
                
                completionHandler(isTyping: data.childrenCount > 0)
            })
        }
    }
    
    
    
}