//
//  Event.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import MapKit



class Event {

    var name: String?
    var date: String?
    var description: String?
    var imageUrlString: String?
    var persons: [Person]?
    var sport: String?
    var placeMark: MKPlacemark?
    
    var adress: String? {
        didSet {
            
            //unowned let weakSelf = self
            CLGeocoder().geocodeAddressString(adress!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if (placemarks?.count > 0) {
                    // should be a weakSelf
                    self.placeMark = MKPlacemark(placemark: (placemarks?[0])!)
                }
            })
        }
    }
    
    
    init() {
        
    }
}