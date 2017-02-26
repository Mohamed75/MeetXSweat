//
//  GPSLocationManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/13/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class GPSLocationManager: UIViewController, CLLocationManagerDelegate {
    
    static let sharedInstance = GPSLocationManager()
    
    var userLocation: CLLocation?
    
    
    fileprivate var locationManager: CLLocationManager?
    
    func startUserLocation() {
        
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        if (Float(UIDevice.current.systemVersion) >= 8) {
            self.locationManager!.requestWhenInUseAuthorization()
        }
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations.first
    }
    
    class func getDistanceFor(_ coordinate: CLLocationCoordinate2D) -> Double {
        
        guard let location = GPSLocationManager.sharedInstance.userLocation else {
            return -1
        }
        let distance = location.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        return distance
    }
}
