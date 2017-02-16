//
//  Event.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import MapKit
import Firebase



class Event: FireBaseObject {

    var name    = ""
    var date    = ""
    var aDescription = ""
    
    var persons: [Person] = []
    var sport   = ""
    
    var imageUrlString = ""
    var placeMark: MKPlacemark?
    
    
    var adress: String? {
        didSet {
            
            CLGeocoder().geocodeAddressString(adress!, completionHandler: { [weak self] (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if (placemarks?.count > 0) {
                    guard let this = self else {
                        return
                    }
                    this.placeMark = MKPlacemark(placemark: (placemarks?[0])!)
                }
            })
        }
    }
    
    func getJour() -> String? {
        if date.characters.count > 1 {
            let array = date.componentsSeparatedByString(" - ")
            if let jour = array.first {
                return jour.stringByReplacingOccurrencesOfString(" ", withString: "/")
            }
        }
        return ""
    }

    func getHeure() -> String? {
        if date.characters.count > 1 {
            let array = date.componentsSeparatedByString(" - ")
            if let heure = array.last {
                return heure.stringByReplacingOccurrencesOfString(":", withString: "H")
            }
        }
        return ""
    }
    
    func isCurrentPersonAlreadyIn() -> Bool {
        
        if persons.count <= 0  {
            return false
        }
        for person in persons {
            if person.email == User.currentUser.email {
                return true
            }
        }
        return false
    }
    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addCurrentUserToEvent() {
        
        if !isCurrentPersonAlreadyIn() {
            persons.append(User.currentUser)
            if let aRef = self.ref {
                aRef.child("persons").setValue(arrayAsJson(persons))
            }
        }
    }
    
    
    
    func saveEventToDataBase() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        self.ref = eventRef.childByAutoId()
        self.ref!.setValue(self.asJson())
    }

}