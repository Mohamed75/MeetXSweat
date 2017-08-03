//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase



private let kFIRPersonChildKey  = "person-items"
private let kFIREmailKey        = "email"
private let kFIRPictureUrlKey   = "pictureUrl"


typealias CompletionDoneBlock = (_ done: Bool) -> Void


/**
 *  This class was designed and implemented to provide a model representation of a Person.
 */

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
    
    // MARK: - *** Get, Save and update data to firebase ***
    
    // Create or update current user if the user already exist on firebase but not on the app yet
    private var handle: DatabaseHandle!
    func createPersonOnDataBase(_ completion: @escaping CompletionDoneBlock) {
        
        let personRef = Database.database().reference().child(kFIRPersonChildKey)
        
        let block: (DataSnapshot) -> Void = { [weak self] snapshot in
            
            guard let this = self else {
                return
            }
            // First time
            if ( snapshot.value is NSNull ) {
                
                this.apnsToken = Utils.getDeviceTokenFromUserDefault()
                
                // save user
                this.ref = personRef.childByAutoId()
                if let aRef = this.ref {
                    aRef.setValue(this.asJson())
                    this.saveToNSUserDefaults()
                    completion(true)
                }
                
            } else { // Person already exist on firebase
                print("user already exist")
                this.loadCurrentPersonFromDB(snapshot)
                completion(true)
            }
            personRef.removeObserver(withHandle: this.handle)
        }
        
        handle = personRef.queryOrdered(byChild: kFIREmailKey).queryEqual(toValue: "\(email)")
            .observe(.value, with: block)
    }
    
    // Load current user data from FireBase, used only by createPersonOnDataBase()
    fileprivate func loadCurrentPersonFromDB(_ snapshot: DataSnapshot) {
        
        for child in snapshot.children {
            let snapUser = User(snapshot: child as! DataSnapshot)
            ref = (child as AnyObject).ref
            copyFromJson(snapUser.asJson())
            User.currentUser.isConnected = true
            saveToNSUserDefaults()
        }
    }
    
    // Update current user with the new data collected on FireBase
    func updatePersonOnDataBase(_ completion: CompletionDoneBlock?) {
        
        saveToNSUserDefaults()
        FireBaseDataManager.updateCurrentUserInPersons()
        
        apnsToken = Utils.getDeviceTokenFromUserDefault()
        
        if let aRef = ref {
            
            aRef.updateChildValues(asJson())
            guard let aCompletion = completion else {
                return
            }
            aCompletion(true)
            
        } else {
            
            let personRef = Database.database().reference().child(kFIRPersonChildKey)
            
            let block: (DataSnapshot) -> Void = { [weak self] snapshot in
                
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
        
            let handle = personRef.queryOrdered(byChild: kFIREmailKey).queryEqual(toValue: "\(email)")
                .observe(.value, with: block)
            personRef.removeObserver(withHandle: handle)
        }
        
    }
    
    // Set current user image
    func setUserImage(_ image: UIImage) {
        
        let completion: ((_ url: String)->Void) = { [weak self] url in
            
            guard let this = self else {
                return
            }
            if let aRef = this.ref {
                aRef.updateChildValues([kFIRPictureUrlKey: url])
                this.pictureUrl = url
                this.saveToNSUserDefaults()
                FireBaseDataManager.updateCurrentUserInPersons()
            }
            else {
                
                let personRef = Database.database().reference().child(kFIRPersonChildKey)
                
                let block: (DataSnapshot) -> Void  = { snapshot in
                    
                    if !( snapshot.value is NSNull ) {
                        
                        print("user image update")
                        for child in snapshot.children {
                            this.ref = (child as AnyObject).ref
                            this.ref!.updateChildValues([kFIRPictureUrlKey: url])
                            this.pictureUrl = url
                            this.saveToNSUserDefaults()
                            FireBaseDataManager.updateCurrentUserInPersons()
                        }
                    }
                }
                
                let handle = personRef.queryOrdered(byChild: kFIREmailKey).queryEqual(toValue: "\(this.email)")
                    .observe(.value, with: block)
                personRef.removeObserver(withHandle: handle)
            }
        }
        
        FireBaseHelper.saveImage(image, fileName: email, completion: completion)
    }
    
    
    func getEvents() -> [Event] {
        EventPersons.fetchEvents(self)
        return EventPersons.sharedInstance.events
    }
    
    
    // MARK: - *** Get Informations  ***
    
    // Email withoutSpecialCharacters
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
