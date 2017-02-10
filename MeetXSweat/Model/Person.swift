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
        let handle = personRef.queryOrderedByChild("email").queryEqualToValue("\(email)")
            .observeEventType(.Value, withBlock: { [weak self] snapshot in
                
                guard let this = self else {
                    return
                }
                if ( snapshot.value is NSNull ) {
                    // save user
                    this.ref = personRef.childByAutoId()
                    this.ref!.setValue(this.asJson())
                    this.saveToNSUserDefaults()
                    
                } else {
                    print("user already exist")
                    this.updateCurrentPersonFromDB(snapshot)
                }
        })
        personRef.removeObserverWithHandle(handle)
    }
    
    
    func updateCurrentPersonFromDB(snapshot: FIRDataSnapshot) {
        
        for child in snapshot.children {
            let snapUser = User(snapshot: child as! FIRDataSnapshot)
            self.ref = child.ref
            self.copyFromJson(snapUser.asJson())
            self.saveToNSUserDefaults()
        }
    }
    
    func updatePersonOnDataBase() {
        
        self.saveToNSUserDefaults()
        
        if let aRef = self.ref {
            
            aRef.updateChildValues(["profession": self.profession])
            aRef.updateChildValues(["sport": self.sport])
            
        } else {
            
            let personRef = FIRDatabase.database().reference().child("person-items")
            let handle = personRef.queryOrderedByChild("email").queryEqualToValue("\(email)")
                .observeEventType(.Value, withBlock: { [weak self] snapshot in
                    
                    guard let this = self else {
                        return
                    }
                    if !( snapshot.value is NSNull ) {
                      
                        print("user finded")
                        for child in snapshot.children {
                            this.ref = child.ref
                            this.ref!.updateChildValues(["profession": this.profession])
                            this.ref!.updateChildValues(["sport": this.sport])
                        }
                    }
            })
            personRef.removeObserverWithHandle(handle)
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
