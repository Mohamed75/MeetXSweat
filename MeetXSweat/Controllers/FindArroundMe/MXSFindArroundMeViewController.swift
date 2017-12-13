//
//  MXSFindArroundMeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import MapKit





/**
 *  This class was designed and implemented to provide a ViewController to find Events arround Current Location.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MKMapView.
 */

class  MXSFindArroundMeViewController: MXSViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    internal var events = FireBaseDataManager.sharedInstance.events
    
    
    // MARK: - *** Others ***
    
    private func addOverlay() {
        
        let overlay = MKTileOverlay(urlTemplate: Constants.URLS.mapTemplate)
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
    }
    
    private func addEvents(_ after: Double) {
        
        MXSActivityIndicator.startAnimating()
        events = FireBaseDataManager.sharedInstance.events
        
        let block = { [weak self] in
            
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
        dispatch_later(after, closure: block)
    }
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBarButtonItem()
        
        title = Strings.NavigationTitle.map

        addOverlay()
        addEvents(4.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MXSFindManager.sharedInstance.findBy = FindBy.arroundMe
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MXSActivityIndicator.stopAnimating()
        super.viewWillDisappear(animated)
    }
    
    override func refreshView() {
        addEvents(1.0)
    }
    
}


// MARK: - *** MapView Delegate ***

extension MXSFindArroundMeViewController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        var region: MKCoordinateRegion = mapView.region
        region.center = (userLocation.location?.coordinate)!
        region.span = MKCoordinateSpanMake(0.4, 0.4)
        mapView.setRegion(region, animated: false)
        
        GPSLocationManager.sharedInstance.userLocation = userLocation.location
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Ressources.MapPinIdentifier.eventsId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Ressources.MapPinIdentifier.eventsId)
        }
        else {
            pinView?.annotation = annotation
        }
        
        pinView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        
        if let aPinView = pinView {
            
            aPinView.canShowCallout = true
            aPinView.isEnabled = true
            let button = UIButton(type: UIButtonType.detailDisclosure)
            button.tintColor = Constants.MainColor.kSpecialColor
            aPinView.rightCalloutAccessoryView = button
            
            guard let subTitle = annotation.subtitle else {
                return pinView
            }
            if let index = Int(subTitle!) {
                aPinView.tag = index
                let event = events[aPinView.tag]
                if let image = UIImage(named: event.sport.lowercased()+"PinBlanc") {
                    aPinView.image = image
                }
            }
            (annotation as? MKPointAnnotation)!.subtitle = ""
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        let event = events[view.tag]
        if let image = UIImage(named: event.sport.lowercased()+"Pin") {
            view.image = image
        }
        dispatch_later(0.01) {
            view.searchViewHierarchy(view)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("Annotation unselected")
        let event = events[view.tag]
        if let image = UIImage(named: event.sport.lowercased()+"PinBlanc") {
            view.image = image
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if view.isKind(of: MKUserLocation.self) {
            return
        }
        
        let eventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.event, viewControllerId: Ressources.StoryBooardsIdentifiers.eventId) as! MXSEventViewController
        eventViewController.event = events[view.tag]
        navigationController?.pushViewController(eventViewController, animated: true)
    }
}


// MARK: - *** Custom MKAnnotationView ***


