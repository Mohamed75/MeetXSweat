//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


class Person: NSObject {
    
    
    var name: String?
    var lastName = ""
    var email = ""
    var profession = ""
    var sport = ""
    var pictureUrl = ""
    var gender = ""
    var birthday = ""
    var events: [Event]?
    var adress: String?
    var ref: FIRDatabaseReference?
    
    func allParams() -> String {
        
        var basicInfo = self.name!
        
        basicInfo = basicInfo + " " + lastName
        basicInfo = basicInfo + " " + email
        basicInfo = basicInfo + " " + profession
        basicInfo = basicInfo + " " + sport
        basicInfo = basicInfo + " " + pictureUrl
        
        basicInfo = basicInfo + " " + gender
        basicInfo = basicInfo + " " + birthday
        
        return basicInfo
    }
    
    override init() {
        ref = nil
    }
    
    init(dictionary: [String : AnyObject]) {
        super.init()
        for key in dictionary.keys {
            self.setValue(dictionary[key], forKey: key)
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        name = snapshot.value!["name"] as? String
        lastName = (snapshot.value!["lastName"] as? String)!
        email = (snapshot.value!["email"] as? String)!
        profession = (snapshot.value!["profession"] as? String)!
        sport = (snapshot.value!["sport"] as? String)!
        pictureUrl = (snapshot.value!["pictureUrl"] as? String)!
        gender = (snapshot.value!["gender"] as? String)!
        birthday = (snapshot.value!["birthday"] as? String)!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: String] {
        
        return [
            "name": name!,
            "lastName": lastName,
            "email": email,
            "profession": profession,
            "sport": sport,
            "pictureUrl": pictureUrl,
            "gender": gender,
            "birthday": birthday
        ]
    }
}
