//
//  Event.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import MapKit



class Event: NSObject {

    var name: String?
    var date: String?
    var aDescription: String?
    var imageUrlString: String?
    var persons: [Person]?
    var sport: String?
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
    
    

}