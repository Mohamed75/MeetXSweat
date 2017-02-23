//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


typealias CompletionDoneBlock = (done: Bool) -> Void



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
    
    func createPersonOnDataBase(completion: CompletionDoneBlock) {
        
        let personRef = FIRDatabase.database().reference().child("person-items")
        
        let block: (FIRDataSnapshot) -> Void = { [weak self] snapshot in
            
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
        }
        
        let handle = personRef.queryOrderedByChild("email").queryEqualToValue("\(email)")
            .observeEventType(.Value, withBlock: block)
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
    
    func updatePersonOnDataBase(completion: CompletionDoneBlock?) {
        
        saveToNSUserDefaults()
        
        if let aRef = ref {
            
            aRef.updateChildValues(asJson())
            
        } else {
            
            let personRef = FIRDatabase.database().reference().child("person-items")
            
            let block: (FIRDataSnapshot) -> Void = { [weak self] snapshot in
                
                guard let this = self else {
                    return
                }
                if !( snapshot.value is NSNull ) {
                    
                    print("user finded")
                    for child in snapshot.children {
                        this.ref = child.ref
                        this.ref!.updateChildValues(this.asJson())
                        guard let aCompletion = completion else {
                            return
                        }
                        aCompletion(done: true)
                    }
                }
            }
        
            let handle = personRef.queryOrderedByChild("email").queryEqualToValue("\(email)")
                .observeEventType(.Value, withBlock: block)
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
                
                let block: (FIRDataSnapshot) -> Void  = { snapshot in
                    
                    if !( snapshot.value is NSNull ) {
                        
                        print("user finded")
                        for child in snapshot.children {
                            this.ref = child.ref
                            this.ref!.updateChildValues(["pictureUrl": url])
                        }
                    }
                }
                
                let handle = personRef.queryOrderedByChild("email").queryEqualToValue("\(this.email)")
                    .observeEventType(.Value, withBlock: block)
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
    
    func professionDomaine() -> String {
        if !domaine.isEmpty {
           return profession + " - " + domaine
        }
        return profession
    }
}
