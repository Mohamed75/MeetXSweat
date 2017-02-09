//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


class Person: FireBaseObject {
    
    var name        = ""
    var lastName    = ""
    var email       = ""
    var profession  = ""
    var sport       = ""
    var pictureUrl  = ""
    var gender      = ""
    var birthday    = ""
    var events: [Event] = []
    var adress      = ""
    
    
    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPersonOnDataBase() {
        
        let personRef = FIRDatabase.database().reference().child("person-items")
        
        personRef.queryOrderedByChild("email").queryEqualToValue("\(email)")
            .observeEventType(.Value, withBlock: { [weak self] snapshot in
                
                guard let this = self else {
                    return
                }
                if ( snapshot.value is NSNull ) {
                    // save user
                    personRef.childByAutoId().setValue(this.asJson())
                } else {
                    print("user already exist")
                    this.updatePerson(snapshot)
                }
        })
    }
    
    
    func updatePerson(snapshot: FIRDataSnapshot) {
        
        for child in snapshot.children {
            let snapUser = User(snapshot: child as! FIRDataSnapshot)
            User.currentUser.copyFromJson(snapUser.asJson())
        }
    }
    
    
    
    // email withoutSpecialCharacters
    func getEmailAsId() -> String {
        
        var returnString = self.email.stringByReplacingOccurrencesOfString("@", withString: "")
        returnString = returnString.stringByReplacingOccurrencesOfString(".", withString: "")
        return returnString
    }
    
    func fullName() -> String {
        return self.name + " " + self.lastName
    }
}
