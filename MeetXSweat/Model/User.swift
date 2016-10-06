//
//  User.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation



class User: Person {
    
    
    var isConnected: Bool = false
    
    static let currentUser = User.loadCustomObject()
    
    
    
    func initFromFBData(data: NSDictionary) {
        
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
        
        saveCustomObject()
    }
    
    
    func initFromTWData(data: NSDictionary) {
        
        if let fullName = data["name"] as? String  {
            let nameArray = fullName.componentsSeparatedByString(" ")
            self.name = nameArray[0]
            if nameArray.count > 1 {
                self.lastName = nameArray[1]
            }
        }
        
        if let email = data["email"] {
            self.email = email as! String
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
        
        saveCustomObject()
    }
    
    func initFromLKData(data: NSDictionary) {
        
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
         
            if let data2 = data3["values"] {
                if let job = data2![0] {
                    if let work = job["title"] {
                        self.profession = work as! String
                    }
                }
            }
        }

        saveCustomObject()
    }
    
    
    func initFromGoogleData(data: NSDictionary) {
        
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
        
        saveCustomObject()
    }
    
    
    func saveCustomObject()
    {
        self.isConnected = true
        
        let object: Person = self
        if object.email.characters.count < 2 {
        
            MXSViewController.getInformationPopUp(Strings.AlertAskingData.email, withCancelButton: false) { (email) in
                
                if email.isValidEmail {
                    object.savePersonToDataBase()
                    object.saveToNSUserDefaults()
                }else {
                    (object as! User).saveCustomObject()
                }
            }
            
        } else {
            
            object.savePersonToDataBase()
            object.saveToNSUserDefaults()
        }
    }
    
    class func loadCustomObject() -> User
    {
        if let myEncodedObject = NSUserDefaults.standardUserDefaults().objectForKey(FireBaseObject.className(String(self))) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(myEncodedObject) as! User
        } else {
           return User()
        }
    }
}