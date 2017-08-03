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

    
    // MARK: - *** Initialisation ***
    
    override init() {
        super.init()
    }
    
    override init(snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - *** Get Informations ***
    
    func toJSQMessage() -> JSQMessage {
        return JSQMessage(senderId: senderId, displayName: "", text: text)
    }
    
}
