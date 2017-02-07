//
//  MXSFindArroundMeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import MapKit


private let reuseId = "MXSPlaceMark"


class  MXSFindArroundMeViewController: MXSViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    var events = FireBaseDataManager.sharedInstance.events
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MSXFindManager.sharedInstance.findBy = FindBy.ArroundMe
        
        self.addBarButtonItem()
        
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        if (Float(UIDevice.currentDevice().systemVersion) >= 8) {
            self.locationManager!.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MXSActivityIndicator.startAnimating()
        
        dispatch_later(4.0) { [weak self] in
        
            guard let this = self else {
                return
            }
            var i = 0
            for event in this.events {
                if let placeMark = event.placeMark {
                    let myPlaceMark = MKPointAnnotation()
                    myPlaceMark.coordinate = placeMark.coordinate
                    myPlaceMark.title = event.name
                    this.mapView.addAnnotation(myPlaceMark)
                    let anotationView = this.mapView.viewForAnnotation(myPlaceMark)
                    anotationView?.tag = i
                    i += 1
                }
            }
            MXSActivityIndicator.stopAnimating()
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        MXSActivityIndicator.stopAnimating()
        super.viewWillDisappear(animated)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        var region: MKCoordinateRegion = self.mapView.region
        region.center = (userLocation.location?.coordinate)!
        region.span = MKCoordinateSpanMake(0.6, 0.6)
        self.mapView.setRegion(region, animated: false)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        else {
            pinView!.annotation = annotation
        }
        pinView!.canShowCallout = true
        pinView?.enabled = true
        pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if view.isKindOfClass(MKUserLocation) {
            return
        }
        
        let eventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.event, viewControllerId: Ressources.StoryBooardsIdentifiers.eventId) as! MXSEventViewController
        eventViewController.event = self.events[view.tag]
        self.navigationController?.pushViewController(eventViewController, animated: true)
    }
}