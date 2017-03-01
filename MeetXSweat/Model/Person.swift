//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


typealias CompletionDoneBlock = (_ done: Bool) -> Void



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
    var apnsToken   = ""
    
    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // create or update current user
    func createPersonOnDataBase(_ completion: @escaping CompletionDoneBlock) {
        
        let personRef = FIRDatabase.database().reference().child("person-items")
        
        let block: (FIRDataSnapshot) -> Void = { [weak self] snapshot in
            
            guard let this = self else {
                return
            }
            if ( snapshot.value is NSNull ) {
                
                if let token = UserDefaults.standard.object(forKey: "apnsToken") as? String {
                    this.apnsToken = token
                }
                // save user
                this.ref = personRef.childByAutoId()
                this.ref!.setValue(this.asJson())
                this.saveToNSUserDefaults()
                completion(true)
                
            } else {
                print("user already exist")
                this.updateCurrentPersonFromDB(snapshot)
                completion(true)
            }
        }
        
        let handle = personRef.queryOrdered(byChild: "email").queryEqual(toValue: "\(email)")
            .observe(.value, with: block)
        personRef.removeObserver(withHandle: handle)
    }
    
    // update current user from FireBase used only by createPersonOnDataBase()
    fileprivate func updateCurrentPersonFromDB(_ snapshot: FIRDataSnapshot) {
        
        for child in snapshot.children {
            let snapUser = User(snapshot: child as! FIRDataSnapshot)
            ref = (child as AnyObject).ref
            copyFromJson(snapUser.asJson())
            User.currentUser.isConnected = true
            saveToNSUserDefaults()
        }
    }
    
    // update current user on FireBase
    func updatePersonOnDataBase(_ completion: CompletionDoneBlock?) {
        
        saveToNSUserDefaults()
        FireBaseDataManager.updateCurrentUserInPersons()
        
        if let token = UserDefaults.standard.object(forKey: "apnsToken") as? String {
            apnsToken = token
        }
        
        if let aRef = ref {
            
            aRef.updateChildValues(asJson())
            guard let aCompletion = completion else {
                return
            }
            aCompletion(true)
            
        } else {
            
            let personRef = FIRDatabase.database().reference().child("person-items")
            
            let block: (FIRDataSnapshot) -> Void = { [weak self] snapshot in
                
                guard let this = self else {
                    return
                }
                if !( snapshot.value is NSNull ) {
                    
                    print("user update")
                    for child in snapshot.children {
                        this.ref = (child as AnyObject).ref
                        this.ref!.updateChildValues(this.asJson())
                        guard let aCompletion = completion else {
                            return
                        }
                        aCompletion(true)
                    }
                }
            }
        
            let handle = personRef.queryOrdered(byChild: "email").queryEqual(toValue: "\(email)")
                .observe(.value, with: block)
            personRef.removeObserver(withHandle: handle)
        }
        
    }
    
    // set current user image
    func setUserImage(_ image: UIImage) {
        
        FireBaseHelper.saveImage(image, fileName: email, completion:  { [weak self] url in
            
            guard let this = self else {
                return
            }
            if let aRef = this.ref {
                aRef.updateChildValues(["pictureUrl": url])
                this.pictureUrl = url
                this.saveToNSUserDefaults()
                FireBaseDataManager.updateCurrentUserInPersons()
            }
            else {
                
                let personRef = FIRDatabase.database().reference().child("person-items")
                
                let block: (FIRDataSnapshot) -> Void  = { snapshot in
                    
                    if !( snapshot.value is NSNull ) {
                        
                        print("user image update")
                        for child in snapshot.children {
                            this.ref = (child as AnyObject).ref
                            this.ref!.updateChildValues(["pictureUrl": url])
                            this.pictureUrl = url
                            this.saveToNSUserDefaults()
                            FireBaseDataManager.updateCurrentUserInPersons()
                        }
                    }
                }
                
                let handle = personRef.queryOrdered(byChild: "email").queryEqual(toValue: "\(this.email)")
                    .observe(.value, with: block)
                personRef.removeObserver(withHandle: handle)
            }
        })
        
        
    }
    
    
    func getEvents() -> [Event] {
        EventPersons.fetchEvents(self)
        return EventPersons.sharedInstance.events
    }
    
    
    // email withoutSpecialCharacters
    func getEmailAsId() -> String {
        
        var returnString = email.replacingOccurrences(of: "@", with: "")
        returnString = returnString.replacingOccurrences(of: ".", with: "")
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
