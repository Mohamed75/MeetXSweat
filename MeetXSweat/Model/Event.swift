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
    
    
    override init() {
        super.init()
    }
    
    override init(snapshot: FIRDataSnapshot) {
        
        super.init(snapshot: snapshot)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func saveEventToDataBase() {
        
        let eventRef = FIRDatabase.database().reference().child("event-items")
        self.ref = eventRef.childByAutoId()
        self.ref!.setValue(self.asJson())
    }

}