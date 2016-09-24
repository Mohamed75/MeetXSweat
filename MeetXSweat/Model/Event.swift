//
//  Event.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


private let geocoder = CLGeocoder()


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
            
            unowned let weakSelf = self
            geocoder.geocodeAddressString(adress!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if (placemarks?.count > 0) {
                    weakSelf.placeMark = MKPlacemark(placemark: (placemarks?[0])!)
                }
            })
        }
    }
    
    
    init() {
        
    }
}