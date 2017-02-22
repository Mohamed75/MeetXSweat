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
    var domaine     = ""
    var sport       = ""
    var pictureUrl  = ""
    var gender      = ""
    var birthday    = ""
    var adress      = ""
    var personDescription = ""
    
    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createPersonOnDataBase(completion:((done: Bool)->Void)) {
        
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
                    completion(done: true)
                    
                } else {
                    print("user already exist")
                    this.updateCurrentPersonFromDB(snapshot)
                    completion(done: true)
                }
        })
        personRef.removeObserverWithHandle(handle)
    }
    
    
    private func updateCurrentPersonFromDB(snapshot: FIRDataSnapshot) {
        
        for child in snapshot.children {
            let snapUser = User(snapshot: child as! FIRDataSnapshot)
            ref = child.ref
            copyFromJson(snapUser.asJson())
            User.currentUser.isConnected = true
            saveToNSUserDefaults()
        }
    }
    
    func updatePersonOnDataBase(completion:((done: Bool)->Void)) {
        
        saveToNSUserDefaults()
        
        if let aRef = ref {
            
            aRef.updateChildValues(asJson())
            
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
                            this.ref!.updateChildValues(this.asJson())
                            completion(done: true)
                        }
                    }
            })
            personRef.removeObserverWithHandle(handle)
        }
    }
    
    func setUserImage(image: UIImage) {
        
        FireBaseHelper.saveImage(image, fileName: email, completion:  { [weak self] url in
            
            guard let this = self else {
                return
            }
            if let aRef = this.ref {
                aRef.updateChildValues(["pictureUrl": url])
            }
            else {
                
                let personRef = FIRDatabase.database().reference().child("person-items")
                let handle = personRef.queryOrderedByChild("email").queryEqualToValue("\(this.email)")
                    .observeEventType(.Value, withBlock: { snapshot in
                        if !( snapshot.value is NSNull ) {
                            
                            print("user finded")
                            for child in snapshot.children {
                                this.ref = child.ref
                                this.ref!.updateChildValues(["pictureUrl": url])
                            }
                        }
                })
                personRef.removeObserverWithHandle(handle)
            }
        })
        
        
    }
    
    
    func getEvents() -> [Event] {
        EventPersons.fetchEvents(self)
        return EventPersons.sharedInstance.events
    }
    
    
    // email withoutSpecialCharacters
    func getEmailAsId() -> String {
        
        var returnString = email.stringByReplacingOccurrencesOfString("@", withString: "")
        returnString = returnString.stringByReplacingOccurrencesOfString(".", withString: "")
        return returnString
    }
    
    func aFullName() -> String {
        return name + " " + lastName
    }
}
