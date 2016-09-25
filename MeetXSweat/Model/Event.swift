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



class Event: MXSObject {

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
    var ref: FIRDatabaseReference?
    
    override init() {
        
        ref = nil
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        
        super.init(snapshot: snapshot)
        ref = snapshot.ref
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func saveEventToDataBase() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        eventRef.childByAutoId().setValue(self.asJson())
    }

}