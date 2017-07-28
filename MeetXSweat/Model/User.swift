//
//  User.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Firebase



typealias CompletionSuccessBlock = (_ success: Bool) -> Void


/**
 *  This class was designed and implemented to inHerite from Person Model to set the object with the data.
 */

class User: Person {
    
    
    var isConnected: Bool = false
    
    static let currentUser = User.loadCustomObject()
    
    
    // Mark: --- SetUp ---
    
    func initFromFBData(_ data: NSDictionary, completion: @escaping CompletionSuccessBlock) {
        
        name = data["first_name"] as! String
        if let alastName = data["last_name"] {
            lastName = alastName as! String
        }
        if let anemail = data["email"] {
            email = anemail as! String
        }
        
        if let data3 = data["picture"] as? NSDictionary {
        
            if let data2 = data3["data"] as? NSDictionary {
                
                if let url = data2["url"] {
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
    
    
    func initFromTWData(_ data: NSDictionary, completion: @escaping CompletionSuccessBlock) {
        
        if let fullName = data["name"] as? String  {
            let nameArray = fullName.components(separatedBy: " ")
            name = nameArray.first!
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
    
    func initFromLKData(_ data: NSDictionary, completion: @escaping CompletionSuccessBlock) {
        
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
        
        if let data3 = data["positions"] as? NSDictionary {
         
            if let dataValues = data3["values"] as? NSArray {
                if let job = dataValues.firstObject as? NSDictionary {
                    if let work = job["title"] {
                        profession = work as! String
                    }
                }
            }
        }
        
        isConnected = true
        saveCustomObject(completion)
    }
    
    
    func initFromGoogleData(_ data: NSDictionary, completion: @escaping CompletionSuccessBlock) {
        
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
    
    
    // Mark: --- SetUp from fireBase ---
    
    func createFromEmailData(_ email: String, password: String, name: String, lastName: String, completion: @escaping CompletionSuccessBlock) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            if (error != nil) {
                
                switch error!._code {
                case 17008:
                    MXSViewController.showInformatifPopUp(Strings.Alert.wrongEmailMesssage)
                    completion(false)
                default:
                    if let errorString = error?.localizedDescription {
                        MXSViewController.showInformatifPopUp(errorString)
                        completion(false)
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
    
    func initFromEmailData(_ email: String, password: String, completion: @escaping CompletionSuccessBlock) {
     
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            
            if (error != nil) {
                
                if let errorString = error?.localizedDescription {
                    MXSViewController.showInformatifPopUp(errorString)
                    completion(false)
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
    
    // Mark: --- Get, Save and update data to firebase ---
    
    // Called when create an new account or logIn
    fileprivate func saveCustomObject(_ completion: @escaping CompletionSuccessBlock)
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
                        this.updatePersonOnDataBase(nil)
                        completion(true)
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
                completion(true)
            })
        }
    }
    
    class func loadCustomObject() -> User
    {
        let className = FireBaseObject.className(String(describing: self))
        if let user = FireBaseObject.loadCustomObjectClassName(className) {
            return user as! User
        } else {
           return User()
        }
    }
    
    
    // Mark: --- LogOut ---
    
    func logOut(_ completion: @escaping CompletionDoneBlock) {
        
        User.currentUser.isConnected = false
        User.currentUser.updatePersonOnDataBase({ (done) in
            
            User.currentUser.name       = ""
            User.currentUser.lastName   = ""
            User.currentUser.email      = ""
            User.currentUser.profession = ""
            User.currentUser.domaine    = ""
            User.currentUser.sport      = ""
            User.currentUser.pictureUrl = ""
            User.currentUser.gender     = ""
            User.currentUser.birthday   = ""
            User.currentUser.adress     = ""
            User.currentUser.personDescription = ""
            User.currentUser.saveToNSUserDefaults()
            
            
            FaceBookHelper.sharedInstance.logOut()
            TwitterHelper.logOut()
            GoogleLogInHelper.sharedInstance.logOut()
            LiknedInHelper.logOut()
            do {
                try FIRAuth.auth()?.signOut()
            } catch {
            
            }
            
            completion(done)
        })
    }
    
    
    // Mark: --- Copy ---
    
    func copyToPerson(_ person: Person) {
        
        person.name     = User.currentUser.name
        person.lastName = User.currentUser.lastName
        person.email    = User.currentUser.email
        person.profession = User.currentUser.profession
        person.domaine  = User.currentUser.domaine
        person.sport    = User.currentUser.sport
        person.pictureUrl = User.currentUser.pictureUrl
        person.gender   = User.currentUser.gender
        person.birthday = User.currentUser.birthday
        person.adress   = User.currentUser.adress
        person.personDescription = User.currentUser.personDescription
    }
}
