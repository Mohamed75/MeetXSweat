//
//  GPSLocationManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/13/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import MapKit


class GPSLocationManager: UIViewController, CLLocationManagerDelegate {
    
    static let sharedInstance = GPSLocationManager()
    
    var userLocation: CLLocation?
    
    
    private var locationManager: CLLocationManager?
    
    func startUserLocation() {
        
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        if (Float(UIDevice.currentDevice().systemVersion) >= 8) {
            self.locationManager!.requestWhenInUseAuthorization()
        }
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations.first
    }
    
    class func getDistanceFor(coordinate: CLLocationCoordinate2D) -> Double {
        let distance = GPSLocationManager.sharedInstance.userLocation!.distanceFromLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        return distance
    }
}