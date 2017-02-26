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
    
    var persons: [String] = []
    var sport   = ""
    
    var imageUrlString  = ""
    var coordinate      = ""
    
    
    var adress: String? {
        didSet {
            
            if coordinate.isEmpty {
                
                let completionHandler = { [weak self] (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                    
                    if let placemarks = placemarks, placemarks.count > 0 {
                        guard let this = self else {
                            return
                        }
                        let coordinate  = MKPlacemark(placemark: placemarks.first!).coordinate
                        this.coordinate = String(coordinate.latitude) + "," + String(coordinate.longitude)
                        this.updateCoordinateEvent()
                    }
                }
                CLGeocoder().geocodeAddressString(adress!, completionHandler: completionHandler as! CLGeocodeCompletionHandler)
            }
        }
    }
    
    
    func getCoordinate() -> CLLocationCoordinate2D? {
        
        let coordinates = coordinate.components(separatedBy: ",")
        if coordinates.count > 1 {
            if let latitude    = Double(coordinates.first!), let longitude   = Double(coordinates.last!) {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
    
    func getJour() -> String? {
        if date.characters.count > 1 {
            let array = date.components(separatedBy: " - ")
            if let jour = array.first {
                return jour.replacingOccurrences(of: " ", with: "/")
            }
        }
        return ""
    }

    func getHeure() -> String? {
        if date.characters.count > 1 {
            let array = date.components(separatedBy: " - ")
            if let heure = array.last {
                return heure.replacingOccurrences(of: ":", with: "H")
            }
        }
        return ""
    }
    
    func isCurrentPersonAlreadyIn() -> Bool {
        
        if persons.count <= 0  {
            return false
        }
        for person in persons {
            if person == User.currentUser.email {
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
        addPersonsObserver()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func getFullPersons() -> [Person] {
        EventPersons.fetchPersons(persons)
        return EventPersons.sharedInstance.persons
    }
    
    
    func addPersonsObserver() {
        
        if let aRef = self.ref {
            aRef.child("persons").observe(.childAdded, with: { [weak self] snapshot in
                
                guard let this = self else {
                    return
                }
                if let person = snapshot.value as? String {
                    if !this.persons.contains(person) {
                        this.persons.append(person)
                    }
                }
            })
        }
    }
    
    
    func addCurrentUserToEvent() {
        
        if !isCurrentPersonAlreadyIn() {
            persons.append(User.currentUser.email)
            if let aRef = ref {
                aRef.child("persons").setValue(persons)
            }
        }
    }
    
    
    func updateCoordinateEvent() {
        
        if let aRef = ref {
            aRef.child("coordinate").setValue(coordinate)
        }
    }
    
    func saveEventToDataBase() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        ref = eventRef.childByAutoId()
        ref!.setValue(asJson())
    }

}
