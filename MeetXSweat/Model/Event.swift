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



class Event: NSObject {

    var name: String?
    var date: String?
    var aDescription: String?
    
    var persons: [Person]?
    var sport: String?
    
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
    
    var imageUrlString = ""
    var placeMark: MKPlacemark?
    let ref: FIRDatabaseReference?
    
    override init() {
        ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        name = snapshot.value!["name"] as? String
        date = snapshot.value!["date"] as? String
        aDescription = snapshot.value!["aDescription"] as? String
        imageUrlString = (snapshot.value!["imageUrlString"] as? String)!
        
        let personsArray = snapshot.value!["persons"] as? [AnyObject]
        persons = []
        for person in personsArray! {
            persons?.append(Person(dictionary: person as! [String : AnyObject]))
        }
        
        sport = snapshot.value!["sport"] as? String
        adress = snapshot.value!["adress"] as? String
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
    
        var anyPersons: [AnyObject] = []
        for person in persons! {
            anyPersons.append(person.toAnyObject())
        }
        return [
            "name": name!,
            "date": date!,
            "aDescription": aDescription!,
            "imageUrlString": imageUrlString,
            "persons": anyPersons,
            "sport": sport!,
            "adress": adress!
        ]
    }
    
    
    
    func saveEventToDataBase() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        eventRef.childByAutoId().setValue(self.toAnyObject())
    }

}