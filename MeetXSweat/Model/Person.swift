//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


class Person: NSObject {
    
    
    var name: String?
    var lastName: String?
    var email: String?
    var profession: String?
    var sport: String?
    var pictureUrl: String?
    var gender: String?
    var birthday: String?
    
    
    
    func allParams() -> String {
        
        var basicInfo = self.name!
        
        if let lastName = self.lastName {
            basicInfo = basicInfo + " " + lastName
        }
        if let email = self.email {
            basicInfo = basicInfo + " " + email
        }
        if let profession = self.profession {
            basicInfo = basicInfo + " " + profession
        }
        if let sport = self.sport {
            basicInfo = basicInfo + " " + sport
        }
        if let pictureUrl = self.pictureUrl {
            basicInfo = basicInfo + " " + pictureUrl
        }
        if let gender = self.gender {
            basicInfo = basicInfo + " " + gender
        }
        if let birthday = self.birthday {
            basicInfo = basicInfo + " " + birthday
        }
        return basicInfo
    }
}
