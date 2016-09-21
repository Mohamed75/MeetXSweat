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
        self.lastName = aDecoder.decodeObjectForKey("lastName") as? String
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.profession = aDecoder.decodeObjectForKey("profession") as? String
        self.sport = aDecoder.decodeObjectForKey("sport") as? String
        self.pictureUrl = aDecoder.decodeObjectForKey("pictureUrl") as? String
        self.gender = aDecoder.decodeObjectForKey("gender") as? String
        self.birthday = aDecoder.decodeObjectForKey("birthday") as? String
        self.isConnected = aDecoder.decodeObjectForKey("isConnected") as! Bool
    }
    
    override init () {
        
    }
    
    func initFromFBData(data: NSDictionary) {
        
        self.name = data["first_name"] as? String
        self.lastName = data["last_name"] as? String
        self.email = data["email"] as? String
        
        if let data3 = data["picture"] {
        
            if let data2 = data3["data"] {
                
                if let url = data2!["url"] {
                    self.pictureUrl = url as? String
                }
            }
        }
        
        self.gender = data["gender"] as? String
        self.birthday = data["birthday"] as? String
        
        self.profession = data["work"] as? String
        
        self.isConnected = true
        User.saveCustomObject(self)
    }
    
    
    func initFromTWData(data: NSDictionary) {
        
        let fullName = data["name"] as! String
        self.name = fullName.componentsSeparatedByString(" ")[0]
        self.lastName = fullName.componentsSeparatedByString(" ")[1]
        self.email = data["email"] as? String
        
        self.pictureUrl = data["profile_image_url"] as? String
        
        self.gender = data["gender"] as? String
        self.birthday = data["birthday"] as? String
        
        self.isConnected = true
        User.saveCustomObject(self)
    }
    
    func initFromLKData(data: NSDictionary) {
        
        self.name = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
        self.email = data["emailAddress"] as? String
        
        self.pictureUrl = data["pictureUrl"] as? String
        
        if let data3 = data["positions"] {
         
            if let data2 = data3["values"] {
                if let job = data2![0] {
                    self.profession = job["title"] as? String
                }
            }
        }

        self.isConnected = true
        User.saveCustomObject(self)
    }
    
    
    func initFromGoogleData(data: NSDictionary) {
        
        self.name = data["given_name"] as? String
        self.lastName = data["family_name"] as? String
        
        self.email = data["email"] as? String
        
        self.pictureUrl = data["picture"] as? String
        self.gender = data["gender"] as? String
        
        self.isConnected = true
        User.saveCustomObject(self)
    }
    
    
    class func saveCustomObject(object: User)
    {
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