//
//  Message.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController


class Message: MXSObject {

    var text: String!
    var senderId: String!
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
    
    
    func toJSQMessage() -> JSQMessage {
        return JSQMessage(senderId: self.senderId, displayName: "", text: self.text)
    }
    
}