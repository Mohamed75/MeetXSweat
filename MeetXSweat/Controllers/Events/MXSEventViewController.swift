//
//  MXSEventsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import MapKit



class MXSEventViewController: MXSViewController {
    
    var event: Event!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var participantsButton: UIButton!
    @IBOutlet weak var inscriptionButton: UIButton!
    
    
    func addOverlay() {
        
        let overlay = MKTileOverlay(URLTemplate: Constants.URL.mapTemplate)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .AboveLabels)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = Ressources.NavigationTitle.event
            
        topView.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        topView.layer.borderWidth = 1
        
        inscriptionButton.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        inscriptionButton.layer.borderWidth = 1
        inscriptionButton.setTitleColor(Constants.MainColor.kSpecialColor, forState: .Normal)
        
        participantsButton.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        participantsButton.layer.borderWidth = 1
        participantsButton.setTitleColor(Constants.MainColor.kSpecialColor, forState: .Normal)
        
        participantsButton.setTitle(String(self.event.persons.count) + " PARTICIPANTS", forState: .Normal)
        
        
        let dateArray = self.event.date.componentsSeparatedByString(" - ")
        var text = dateArray[0]
        text = text + "       " + self.event.sport + "\n"
        if dateArray.count > 1 {
            text = text + dateArray[1]
        }
        
        addOverlay()
        
        if let placeMark = event.placeMark {
            
            let myPlaceMark = MKPointAnnotation()
            myPlaceMark.coordinate  = placeMark.coordinate
            myPlaceMark.title       = event.name
            self.mapView.addAnnotation(myPlaceMark)
            
        } else {
            self.event.adress = self.event.adress
        }
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
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(Ressources.MapPinIdentifier.eventId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Ressources.MapPinIdentifier.eventId)
            pinView!.transform = CGAffineTransformMakeScale(1.5, 1.5)
        }
        else {
            pinView!.annotation = annotation
        }
        
        if let aPinView = pinView {
            
            aPinView.canShowCallout = true
            aPinView.enabled = true
            let button = UIButton(type: UIButtonType.DetailDisclosure)
            button.tintColor = Constants.MainColor.kSpecialColor
            aPinView.rightCalloutAccessoryView = button
            
            if let image = UIImage(named: event.sport.lowercaseString+"PinBlanc") {
                aPinView.image = image
            }
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")
        if let image = UIImage(named: event.sport.lowercaseString+"Pin") {
            view.image = image
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("Annotation unselected")
        if let image = UIImage(named: event.sport.lowercaseString+"PinBlanc") {
            view.image = image
        }
    }
    
    
    @IBAction func inscriptionButtonClicked(sender: AnyObject) {
    }
}
