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


/**
 *  This class was designed and implemented to provide a model representation of a Conversation.
 */

class Conversation: FireBaseObject {

    var persons: [String] = []
    var messages: [Message] = []
    
    
    // Mark: --- Initialisation ---
    
    override init() {
        super.init()
    }
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Mark: --- Get, Save and update data to firebase ---
    
    func getFullPersons() -> [Person] {
        EventPersons.fetchPersons(persons)
        return EventPersons.sharedInstance.persons
    }
    
    private var messagesQuery: DatabaseReference?
    func observeMessages(_ completionHandler:@escaping ((_ messages: [Message])->Void)) {
        
        if let conversationRef = ref {
            
            self.messages = []
            messagesQuery = conversationRef.child("messages")
            
            let block: (DataSnapshot) -> Void = { [weak self] (snapshot) in
                
                guard let this = self else {
                    return
                }
                let message = Message(snapshot: snapshot)
                this.messages.append(message)
                
                completionHandler(this.messages)
            }
            
            messagesQuery!.queryLimited(toLast: 100).observe(.childAdded, with: block)
        }
    }
    
    func removeObservers() {
        
        if let conversationRef = messagesQuery {
            conversationRef.removeAllObservers()
        }
    }
    
    func addMessage(_ text: String, senderId: String, controller: ChatViewController?) {
        
        if let conversationRef = ref { // add message to current conversation
            
            let itemRef = conversationRef.child("messages").childByAutoId()
            let message = Message()
            message.text = text
            message.senderId = senderId
            itemRef.setValue(message.asJson())
            
        } else { // create conversation if doesn't exist
            
            let conversationRef = Database.database().reference().child("conversation-items")
            let aRef = conversationRef.childByAutoId()
            aRef.setValue(asJson())
            ref = aRef
            addMessage(text, senderId: senderId, controller: nil)
            controller!.viewDidAppear(false)//to restart the observers
        }
    }
    
    
    
    
    
    var userIsTypingRef: DatabaseReference!
    
    fileprivate var localTyping = false
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
    
    func observeTyping(_ senderId: String, completionHandler:@escaping ((_ isTyping: Bool)->Void)) {
        
        if let conversationRef = ref {
        
            let typingIndicatorRef = conversationRef.child("typingIndicator")
            userIsTypingRef = typingIndicatorRef.child(senderId)
            userIsTypingRef.onDisconnectRemoveValue()
            let usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
            
            let block: (DataSnapshot) -> Void = { [weak self] (snapshot) in
                guard let this = self else {
                    return
                }
                // You're the only typing, don't show the indicator
                if snapshot.childrenCount == 1 && this.isTyping {
                    return
                }
                
                completionHandler(snapshot.childrenCount > 0)
            }
            
            usersTypingQuery.observe(.value, with: block)
        }
    }
    
    
    // Mark: --- Get Informations  ---
    
    func isCurrentUserConversation() -> Bool {
        
        for person in persons {
            if person == User.currentUser.email {
                return true
            }
        }
        return false
    }
    
}
