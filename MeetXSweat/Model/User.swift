//
//  User.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation



class User: Person, NSCoding {
    
    
    var isConnected: Bool = false
    
    static let currentUser = User.loadCustomObjectWithKey("SAVED_USER")
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.profession, forKey: "profession")
        aCoder.encodeObject(self.sport, forKey: "sport")
        aCoder.encodeObject(self.pictureUrl, forKey: "pictureUrl")
        aCoder.encodeObject(self.gender, forKey: "gender")
        aCoder.encodeObject(self.birthday, forKey: "birthday")
        aCoder.encodeObject(self.isConnected, forKey: "isConnected")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as! String
        self.email = aDecoder.decodeObjectForKey("email") as! String
        self.profession = aDecoder.decodeObjectForKey("profession") as! String
        self.sport = aDecoder.decodeObjectForKey("sport") as! String
        self.pictureUrl = aDecoder.decodeObjectForKey("pictureUrl") as! String
        self.gender = aDecoder.decodeObjectForKey("gender") as! String
        self.birthday = aDecoder.decodeObjectForKey("birthday") as! String
        self.isConnected = aDecoder.decodeObjectForKey("isConnected") as! Bool
    }
    
    override init () {
        super.init()
    }
    
    func initFromFBData(data: NSDictionary) {
        
        self.name = data["first_name"] as? String
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
        User.saveCustomObject(self)
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
        
        self.isConnected = true
        User.saveCustomObject(self)
    }
    
    func initFromLKData(data: NSDictionary) {
        
        self.name = data["firstName"] as? String
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

        self.isConnected = true
        User.saveCustomObject(self)
    }
    
    
    func initFromGoogleData(data: NSDictionary) {
        
        self.name = data["given_name"] as? String
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
        User.saveCustomObject(self)
    }
    
    
    class func saveCustomObject(object: Person)
    {
        object.savePersonToDataBase()
        
        let myEncodedObject = NSKeyedArchiver.archivedDataWithRootObject(object)
        NSUserDefaults.standardUserDefaults().setObject(myEncodedObject, forKey:"SAVED_USER")
    }
    
    class func loadCustomObjectWithKey(key: NSString) -> User
    {
        if let myEncodedObject = NSUserDefaults.standardUserDefaults().objectForKey(key as String) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(myEncodedObject) as! User
        } else {
           return User()
        }
    }
}