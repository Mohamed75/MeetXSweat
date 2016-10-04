//
//  Person.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


class Person: MXSObject {
    
    
    var name: String?
    var lastName = ""
    var email = ""
    var profession = ""
    var sport = ""
    var pictureUrl = ""
    var gender = ""
    var birthday = ""
    var events: [Event]?
    var adress = ""
    var ref: FIRDatabaseReference?
    
    
    
    override init() {
        super.init()
        ref = nil
    }
    
    override init(dictionary: [String : AnyObject]) {
        super.init(dictionary: dictionary)
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
        ref = snapshot.ref
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func savePersonToDataBase() {
        
        let personRef = FIRDatabase.database().reference().child("person-items")
        
        personRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.hasChild(self.email){
                print("user already exist")
            }else{
                // save user
                personRef.childByAutoId().setValue(self.asJson())
            }
        });
    }
}
