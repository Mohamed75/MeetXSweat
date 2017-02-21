//
//  User.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Firebase





class User: Person {
    
    
    var isConnected: Bool = false
    
    static let currentUser = User.loadCustomObject()
    
    
    
    func initFromFBData(data: NSDictionary, completion:((success: Bool)->Void)) {
        
        self.name = data["first_name"] as! String
        if let lastName = data["last_name"] {
            self.lastName = lastName as! String
        }
        if let email = data["email"] {
            self.email = email as! String
        }
        
        if let data3 = data["picture"] {
        
            if let data2 = data3["data"] {
                
                if let url = data2!["url"] {
                    self.pictureUrl = url as! String
                }
            }
        }
        
        if let gender = data["gender"] {
            self.gender = gender as! String
        }
        if let birthday = data["birthday"] {
            self.birthday = birthday as! String
        }
        if let work = data["work"] {
            self.profession = work as! String
        }
        
        self.isConnected = true
        saveCustomObject(completion)
    }
    
    
    func initFromTWData(data: NSDictionary, completion:((success: Bool)->Void)) {
        
        if let fullName = data["name"] as? String  {
            let nameArray = fullName.componentsSeparatedByString(" ")
            self.name = nameArray[0]
            if nameArray.count > 1 {
                self.lastName = nameArray[1]
            }
        }
        
        if let email = data["email"] {
            self.email = email as! String
        } else {
            if let screenName = data["screen_name"] {
                self.email = (screenName as! String)+"@twitter.fr"
            }
        }
        
        if let pictureUrl = data["profile_image_url"] {
            self.pictureUrl = pictureUrl as! String
        }
        
        if let gender = data["gender"] {
            self.gender = gender as! String
        }
        if let birthday = data["birthday"] {
            self.birthday = birthday as! String
        }
        
        self.isConnected = true
        saveCustomObject(completion)
    }
    
    func initFromLKData(data: NSDictionary, completion:((success: Bool)->Void)) {
        
        self.name = data["firstName"] as! String
        if let lastName = data["lastName"] {
            self.lastName = lastName as! String
        }
        
        if let email = data["emailAddress"] {
            self.email = email as! String
        }
        
        if let pictureUrl = data["pictureUrl"] {
            self.pictureUrl = pictureUrl as! String
        }
        
        if let data3 = data["positions"] {
         
            if let dataValues = data3["values"] {
                if let job = dataValues?.firstObject {
                    if let work = job!["title"] {
                        self.profession = work as! String
                    }
                }
            }
        }
        
        self.isConnected = true
        saveCustomObject(completion)
    }
    
    
    func initFromGoogleData(data: NSDictionary, completion:((success: Bool)->Void)) {
        
        self.name = data["given_name"] as! String
        if let lastName = data["family_name"] {
            self.lastName = lastName as! String
        }
        
        if let email = data["email"] {
            self.email = email as! String
        }
        
        if let pictureUrl = data["picture"] {
            self.pictureUrl = pictureUrl as! String
        }
        
        if let gender = data["gender"] {
            self.gender = gender as! String
        }
        
        self.isConnected = true
        saveCustomObject(completion)
    }
    
    
    func createFromEmailData(email: String, password: String, name: String, lastName: String, completion:((success: Bool)->Void)) {
        
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
    
    func initFromEmailData(email: String, password: String, completion:((success: Bool)->Void)) {
     
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { [weak self] (user, error) in
            
            if (error != nil) {
                
                if let errorString = error?.localizedDescription {
                    MXSViewController.showInformatifPopUp(errorString)
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
    private func saveCustomObject(completion:((success: Bool)->Void))
    {
        let object: Person = self
        if object.email.characters.count < 2 { // Should Not happen
            
            MXSViewController.getInformationPopUp(Strings.Alert.enterEmailMessage, withCancelButton: false) { [weak self] (email) in
                
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
                    (object as! User).saveCustomObject(completion)
                }
            }
            
        } else {
            
            object.createPersonOnDataBase({ [weak self] (done) in
                
                guard let this = self else {
                    return
                }
                this.updatePersonOnDataBase({ (done) in
                })
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
    
    
    func logOut() {
        
        User.currentUser.isConnected = false
        User.currentUser.updatePersonOnDataBase({ (done) in
            User.currentUser.pictureUrl = ""
            User.currentUser.name       = ""
            User.currentUser.lastName   = ""
            User.currentUser.email      = ""
            User.currentUser.profession = ""
            User.currentUser.sport      = ""
            User.currentUser.gender     = ""
            User.currentUser.birthday   = ""
            User.currentUser.events     = []
            User.currentUser.adress     = ""
            User.currentUser.saveToNSUserDefaults()
        })
    }
}