//
//  User.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Firebase



typealias CompletionSuccessBlock = (success: Bool) -> Void



class User: Person {
    
    
    var isConnected: Bool = false
    
    static let currentUser = User.loadCustomObject()
    
    
    
    func initFromFBData(data: NSDictionary, completion: CompletionSuccessBlock) {
        
        name = data["first_name"] as! String
        if let alastName = data["last_name"] {
            lastName = alastName as! String
        }
        if let anemail = data["email"] {
            email = anemail as! String
        }
        
        if let data3 = data["picture"] {
        
            if let data2 = data3["data"] {
                
                if let url = data2!["url"] {
                    pictureUrl = url as! String
                }
            }
        }
        
        if let agender = data["gender"] {
            gender = agender as! String
        }
        if let abirthday = data["birthday"] {
            birthday = abirthday as! String
        }
        if let work = data["work"] {
            profession = work as! String
        }
        
        isConnected = true
        saveCustomObject(completion)
    }
    
    
    func initFromTWData(data: NSDictionary, completion: CompletionSuccessBlock) {
        
        if let fullName = data["name"] as? String  {
            let nameArray = fullName.componentsSeparatedByString(" ")
            name = nameArray[0]
            if nameArray.count > 1 {
                lastName = nameArray[1]
            }
        }
        
        if let anemail = data["email"] {
            email = anemail as! String
        } else {
            if let screenName = data["screen_name"] {
                email = (screenName as! String)+"@twitter.fr"
            }
        }
        
        if let apictureUrl = data["profile_image_url"] {
            pictureUrl = apictureUrl as! String
        }
        
        if let agender = data["gender"] {
            gender = agender as! String
        }
        if let abirthday = data["birthday"] {
            birthday = abirthday as! String
        }
        
        isConnected = true
        saveCustomObject(completion)
    }
    
    func initFromLKData(data: NSDictionary, completion: CompletionSuccessBlock) {
        
        name = data["firstName"] as! String
        if let alastName = data["lastName"] {
            lastName = alastName as! String
        }
        
        if let anemail = data["emailAddress"] {
            email = anemail as! String
        }
        
        if let apictureUrl = data["pictureUrl"] {
            pictureUrl = apictureUrl as! String
        }
        
        if let data3 = data["positions"] {
         
            if let dataValues = data3["values"] {
                if let job = dataValues?.firstObject {
                    if let work = job!["title"] {
                        profession = work as! String
                    }
                }
            }
        }
        
        isConnected = true
        saveCustomObject(completion)
    }
    
    
    func initFromGoogleData(data: NSDictionary, completion: CompletionSuccessBlock) {
        
        name = data["given_name"] as! String
        if let alastName = data["family_name"] {
            lastName = alastName as! String
        }
        
        if let anemail = data["email"] {
            email = anemail as! String
        }
        
        if let apictureUrl = data["picture"] {
            pictureUrl = apictureUrl as! String
        }
        
        if let agender = data["gender"] {
            gender = agender as! String
        }
        
        isConnected = true
        saveCustomObject(completion)
    }
    
    
    func createFromEmailData(email: String, password: String, name: String, lastName: String, completion: CompletionSuccessBlock) {
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { [weak self] (user, error) in
            
            if (error != nil) {
                
                switch error!.code {
                case 17008:
                    MXSViewController.showInformatifPopUp(Strings.Alert.wrongEmailMesssage)
                default:
                    if let errorString = error?.localizedDescription {
                        MXSViewController.showInformatifPopUp(errorString)
                    }
                }
                
            } else {
                
                guard let this = self else {
                    return
                }
                this.email  = email
                this.name   = name
                this.lastName = lastName
                this.isConnected = true
                this.saveCustomObject(completion)
            }
        }
    }
    
    func initFromEmailData(email: String, password: String, completion: CompletionSuccessBlock) {
     
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { [weak self] (user, error) in
            
            if (error != nil) {
                
                if let errorString = error?.localizedDescription {
                    MXSViewController.showInformatifPopUp(errorString)
                    completion(success: false)
                }
                
            } else {
                
                guard let this = self else {
                    return
                }
                this.email  = email
                this.isConnected = true
                this.saveCustomObject(completion)
            }
        })
    }
    
   
    // Called when create an new account or logIn
    private func saveCustomObject(completion: CompletionSuccessBlock)
    {
        let object: Person = self
        if object.email.characters.count < 2 { // Should Not happen
            
            MXSViewController.showInformationPopUp(Strings.Alert.enterEmailMessage, withCancelButton: false) { [weak self] (email) in
                
                guard let this = self else {
                    return
                }
                if email.isValidEmail {
                    this.email = email
                    object.createPersonOnDataBase({ (done) in
                        this.updatePersonOnDataBase({ (done) in
                        })
                        completion(success: true)
                    })
                }else {
                    if let aUser = object as? User {
                        aUser.saveCustomObject(completion)
                    }
                }
            }
            
        } else {
            
            object.createPersonOnDataBase({ [weak self] (done) in
                
                guard let this = self else {
                    return
                }
                this.updatePersonOnDataBase(nil)
                completion(success: true)
            })
        }
    }
    
    class func loadCustomObject() -> User
    {
        let className = FireBaseObject.className(String(self))
        if let user = FireBaseObject.loadCustomObjectClassName(className) {
            return user as! User
        } else {
           return User()
        }
    }
    
    
    func logOut(completion: CompletionDoneBlock) {
        
        User.currentUser.isConnected = false
        User.currentUser.updatePersonOnDataBase({ (done) in
            User.currentUser.pictureUrl = ""
            User.currentUser.name       = ""
            User.currentUser.lastName   = ""
            User.currentUser.email      = ""
            User.currentUser.profession = ""
            User.currentUser.domaine    = ""
            User.currentUser.sport      = ""
            User.currentUser.gender     = ""
            User.currentUser.birthday   = ""
            User.currentUser.adress     = ""
            User.currentUser.personDescription = ""
            User.currentUser.saveToNSUserDefaults()
            completion(done: done)
        })
    }
}