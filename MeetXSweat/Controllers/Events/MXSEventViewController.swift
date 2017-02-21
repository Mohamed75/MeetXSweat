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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heurLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    
    
    // stackView
    @IBOutlet weak var jourLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var stackWidthConstraint: NSLayoutConstraint!
    
    
    
    func timeLeft() {
        
        MXSCalendarViewController.formatter.dateFormat = kDateFormat
        if let timeLeft = MXSCalendarViewController.formatter.dateFromString(event.date)?.timeIntervalSinceNow {
        
            let joures = Int(timeLeft/86400)
            jourLabel.text  = String(joures)
            if joures < 10 {
                jourLabel.text = " " + String(joures)
            }
            
            let houres = Int(timeLeft/3600.0)%24
            hourLabel.text  = String(houres)
            if houres < 10 {
                hourLabel.text = " " + String(houres)
            }
            
            let minutes = Int(timeLeft/60.0)%60
            minuteLabel.text = String(minutes)
            if minutes < 10 {
                minuteLabel.text = " " + String(minutes)
            }
            
            let seconds = Int(timeLeft%60)
            secondLabel.text = String(seconds)
            if seconds < 10 {
                secondLabel.text = " " + String(seconds)
            }
        }
        
        dispatch_later(1) { [weak self] in
            guard let this = self else {
                return
            }
            this.timeLeft()
        }
    }
    
    
    func addOverlay() {
        
        let overlay = MKTileOverlay(URLTemplate: Constants.URL.mapTemplate)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .AboveLabels)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UIScreen.mainScreen().bounds.width < 375 {
            self.sportLabel.hidden = true
        } else {
            if UIScreen.mainScreen().bounds.width == 375 {
                stackWidthConstraint.constant = -54
            } else {
                stackWidthConstraint.constant = -90
            }
        }
        
        if let jour = event.getJour(), heure = event.getHeure() {
            dateLabel.text = jour
            heurLabel.text = heure
            timeLeft()
        }
        
        if let coordinate = event.getCoordinate() {
            let km = GPSLocationManager.getDistanceFor(coordinate)/1000
            if km > 0 {
                mapLabel.text = String(format: "%.1fKM", km)
            }
        }
        
        sportLabel.text = event.sport
        
        jourLabel.textColor = Constants.MainColor.kSpecialColor
        hourLabel.textColor = Constants.MainColor.kSpecialColor
        minuteLabel.textColor = Constants.MainColor.kSpecialColor
        secondLabel.textColor = Constants.MainColor.kSpecialColor
        
        self.title = Ressources.NavigationTitle.event
            
        topView.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        topView.layer.borderWidth = 1
        
        inscriptionButton.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        inscriptionButton.layer.borderWidth = 1
        inscriptionButton.setTitleColor(Constants.MainColor.kSpecialColor, forState: .Normal)
        
        participantsButton.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        participantsButton.layer.borderWidth = 1
        participantsButton.setTitleColor(Constants.MainColor.kSpecialColor, forState: .Normal)
        
        updateParticipantsButtonText()
        updateInscriptionButton()
        
        let dateArray = self.event.date.componentsSeparatedByString(" - ")
        var text = dateArray[0]
        text = text + "       " + self.event.sport + "\n"
        if dateArray.count > 1 {
            text = text + dateArray[1]
        }
        
        addOverlay()
        
        if let coordinate = event.getCoordinate() {
            
            let myPlaceMark = MKPointAnnotation()
            myPlaceMark.coordinate  = coordinate
            myPlaceMark.title       = event.name
            self.mapView.addAnnotation(myPlaceMark)
            
        } else {
            self.event.adress = self.event.adress
        }
        
        if self.tabBarController?.selectedIndex == 0 {
            participantsButton.hidden = true
        }
    }
    
    func updateParticipantsButtonText() {
        participantsButton.setTitle(String(self.event.persons.count) + " PARTICIPANTS", forState: .Normal)
    }
    
    func updateInscriptionButton() {
        
        if self.event.isCurrentPersonAlreadyIn() {
            inscriptionButton.enabled = false
            inscriptionButton.alpha = 0.4
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
    
    @IBAction func participantsButtonClicked(sender: AnyObject) {
        
        if event.persons.count <= 0 {
            return
        }
        
        if let viewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.embedProfilesId) as? MXSEmbedCollectionViewController
        {
            viewController.title = Ressources.NavigationTitle.sportsParticipants
            self.navigationController?.pushViewController(viewController, animated: false)
            
            
            dispatch_later(0.1, closure: { [weak self] in
                guard let this = self else {
                    return
                }
                if let personsCollectionViewController = viewController.childViewControllers[0] as? MXSPersonsCollectionViewController {
                    viewController.titleLabel.text = this.event.sport.uppercaseString
                    if let jour = this.event.getJour(), heure = this.event.getHeure() {
                        viewController.titleLabel.text = this.event.sport.uppercaseString + " - " + jour + " - " + heure
                    }
                    personsCollectionViewController.persons = this.event.getPersons()
                    personsCollectionViewController.collectionView?.reloadData()
                }
            })
        }
    }
    
    @IBAction func inscriptionButtonClicked(sender: AnyObject) {
        event.addCurrentUserToEvent()
        if self.tabBarController?.selectedIndex != 0 {
            participantsButtonClicked(NSObject())
        }
        updateParticipantsButtonText()
        updateInscriptionButton()
    }
}
