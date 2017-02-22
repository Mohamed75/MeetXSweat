//
//  MXSFindArroundMeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import MapKit







class  MXSFindArroundMeViewController: MXSViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var events = FireBaseDataManager.sharedInstance.events
    
    
    func addOverlay() {
        
        let overlay = MKTileOverlay(URLTemplate: Constants.URL.mapTemplate)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .AboveLabels)
    }
    
    func addEvents(after: Double) {
        
        MXSActivityIndicator.startAnimating()
        
        dispatch_later(after) { [weak self] in
            
            guard let this = self else {
                return
            }
            this.mapView.removeAnnotations(this.mapView.annotations)
            var i = 0
            for event in this.events {
                
                if let coordinate = event.getCoordinate() {
                    
                    let myPlaceMark = MKPointAnnotation()
                    myPlaceMark.coordinate  = coordinate
                    myPlaceMark.title       = event.name
                    myPlaceMark.subtitle    = String(i)
                    this.mapView.addAnnotation(myPlaceMark)
                    i += 1
                }
            }
            MXSActivityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBarButtonItem()
        
        self.title = Strings.NavigationTitle.map

        addOverlay()
        addEvents(4.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MSXFindManager.sharedInstance.findBy = FindBy.ArroundMe
    }
    
    override func viewWillDisappear(animated: Bool) {
        MXSActivityIndicator.stopAnimating()
        super.viewWillDisappear(animated)
    }
    
    override func refreshView() {
        addEvents(1.0)
    }
    
    
    // Mark: --- MapView ---
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        var region: MKCoordinateRegion = self.mapView.region
        region.center = (userLocation.location?.coordinate)!
        region.span = MKCoordinateSpanMake(0.4, 0.4)
        self.mapView.setRegion(region, animated: false)
        
        GPSLocationManager.sharedInstance.userLocation = userLocation.location
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(Ressources.MapPinIdentifier.eventsId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Ressources.MapPinIdentifier.eventsId)
        }
        else {
            pinView!.annotation = annotation
        }
        
        pinView!.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        if let aPinView = pinView {
            
            aPinView.canShowCallout = true
            aPinView.enabled = true
            let button = UIButton(type: UIButtonType.DetailDisclosure)
            button.tintColor = Constants.MainColor.kSpecialColor
            aPinView.rightCalloutAccessoryView = button
            
            guard let subTitle = annotation.subtitle else {
                return pinView
            }
            if let index = Int(subTitle!) {
                aPinView.tag = index
                let event = self.events[aPinView.tag]
                if let image = UIImage(named: event.sport.lowercaseString+"PinBlanc") {
                    aPinView.image = image
                }
            }
            (annotation as? MKPointAnnotation)!.subtitle = ""
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")
        let event = self.events[view.tag]
        if let image = UIImage(named: event.sport.lowercaseString+"Pin") {
            view.image = image
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("Annotation unselected")
        let event = self.events[view.tag]
        if let image = UIImage(named: event.sport.lowercaseString+"PinBlanc") {
            view.image = image
        }
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


extension MKAnnotationView {
    
    public override func layoutSubviews () {
        
        if (!selected) {
            return
        }
        super.layoutSubviews()
        for view in subviews {
            searchViewHierarchy (view)
        }
    }
    
    func searchViewHierarchy(aPinView: UIView) {
        
        for subView in aPinView.subviews {
            if (subView is UILabel) {
                (subView as! UILabel).textColor = Constants.MainColor.kSpecialColor
            } else {
                searchViewHierarchy (subView)
            }
        }
    }

}