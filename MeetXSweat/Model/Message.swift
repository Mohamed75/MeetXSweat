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


class Message: FireBaseObject {

    var text        = ""
    var senderId    = ""

    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func toJSQMessage() -> JSQMessage {
        return JSQMessage(senderId: senderId, displayName: "", text: text)
    }
    
}