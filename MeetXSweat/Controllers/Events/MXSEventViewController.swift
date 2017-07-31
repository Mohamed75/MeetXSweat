//
//  MXSEventsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import MapKit


private let kDaySeconds  = 86400.0
private let kHourSeconds = 3600.0
private let kMinuteSeconds = 60.0
private let kHours       = 24



/**
 *  This class was designed and implemented to provide an Event ViewController.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MXSCalendarViewController.
 - helper       Utils.
 */

class MXSEventViewController: MXSViewController {
    
    internal var event: Event!
    
    
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
    
    
    
    private func timeLeft() {
        
        MXSCalendarViewController.formatter.dateFormat = kDateFormat
        if let timeLeft = MXSCalendarViewController.formatter.date(from: event.date)?.timeIntervalSinceNow {
        
            let joures = Int(timeLeft/kDaySeconds)
            jourLabel.text  = String(joures)
            if joures < 10 {
                jourLabel.text = " " + String(joures)
            }
            
            let houres = Int(timeLeft/kHourSeconds)%kHours
            hourLabel.text  = String(houres)
            if houres < 10 {
                hourLabel.text = " " + String(houres)
            }
            
            let minutes = Int(timeLeft/kMinuteSeconds)%Int(kMinuteSeconds)
            minuteLabel.text = String(minutes)
            if minutes < 10 {
                minuteLabel.text = " " + String(minutes)
            }
            
            let seconds = Int(timeLeft.truncatingRemainder(dividingBy: kMinuteSeconds))
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
    
    
    private func addOverlay() {
        
        let overlay = MKTileOverlay(urlTemplate: Constants.URLS.mapTemplate)
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
    }
    
    
    // Mark: ---  View lifecycle ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if ScreenSize.currentWidth < ScreenSize.iphone6Width {
            self.sportLabel.isHidden = true
        } else {
            if ScreenSize.currentWidth == ScreenSize.iphone6Width {
                stackWidthConstraint.constant = -54
            } else {
                stackWidthConstraint.constant = -90
            }
        }
        
        if let jour = event.getJour(), let heure = event.getHeure() {
            dateLabel.text = jour
            heurLabel.text = heure
            timeLeft()
        }
        
        if let coordinate = event.getCoordinate() {
            let km = GPSLocationManager.getDistanceFor(coordinate)/Constants.mToKm
            if km > 0 {
                mapLabel.text = String(format: "%.1fKM", km)
            }
        }
        
        sportLabel.text = event.sport
        
        jourLabel.textColor = Constants.MainColor.kSpecialColor
        hourLabel.textColor = Constants.MainColor.kSpecialColor
        minuteLabel.textColor = Constants.MainColor.kSpecialColor
        secondLabel.textColor = Constants.MainColor.kSpecialColor
        
        title = Strings.NavigationTitle.event
            
        topView.layer.borderColor = Constants.MainColor.kSpecialColor.cgColor
        topView.layer.borderWidth = 1
        
        inscriptionButton.layer.borderColor = Constants.MainColor.kSpecialColor.cgColor
        inscriptionButton.layer.borderWidth = 1
        inscriptionButton.setTitleColor(Constants.MainColor.kSpecialColor, for: UIControlState())
        
        participantsButton.layer.borderColor = Constants.MainColor.kSpecialColor.cgColor
        participantsButton.layer.borderWidth = 1
        participantsButton.setTitleColor(Constants.MainColor.kSpecialColor, for: UIControlState())
        
        updateParticipantsButtonText()
        updateInscriptionButton()
        
        let dateArray = event.date.components(separatedBy: " - ")
        var text = dateArray.first
        text = text! + "       " + event.sport + "\n"
        if dateArray.count > 1 {
            text = text! + dateArray[1]
        }
        
        addOverlay()
        
        if let coordinate = event.getCoordinate() {
            
            let myPlaceMark = MKPointAnnotation()
            myPlaceMark.coordinate  = coordinate
            myPlaceMark.title       = event.name
            mapView.addAnnotation(myPlaceMark)
            
        } else {
            event.adress = event.adress
        }
        
        if tabBarController?.selectedIndex == 0 {
            participantsButton.isHidden = true
        }
    }
    
    private func updateParticipantsButtonText() {
        participantsButton.setTitle(String(event.persons.count) + " PARTICIPANTS", for: UIControlState())
    }
    
    private func updateInscriptionButton() {
        
        if event.isCurrentPersonAlreadyIn() {
            inscriptionButton.isEnabled = false
            inscriptionButton.alpha = 0.4
        }
    }
    
    
    // Mark: --- Button Actions ---
    
    @IBAction func participantsButtonClicked(_ sender: AnyObject) {
        
        if event.persons.count <= 0 {
            return
        }
        
        if let viewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.embedProfilesId) as? MXSFindCollectionViewController
        {
            viewController.title = Strings.NavigationTitle.sportsParticipants
            navigationController?.pushViewController(viewController, animated: false)
            
            
            dispatch_later(0.1, closure: { [weak self] in
                guard let this = self else {
                    return
                }
                if let personsCollectionViewController = viewController.childViewControllers.first as? MXSPersonsCollectionViewController {
                    viewController.titleLabel.text = this.event.sport.uppercased()
                    if let jour = this.event.getJour(), let heure = this.event.getHeure() {
                        viewController.titleLabel.text = this.event.sport.uppercased() + " - " + jour + " - " + heure
                    }
                    personsCollectionViewController.persons = this.event.getFullPersons()
                    personsCollectionViewController.collectionView?.reloadData()
                }
            })
        }
    }
    
    @IBAction func inscriptionButtonClicked(_ sender: AnyObject) {
        event.addCurrentUserToEvent()
        if tabBarController?.selectedIndex != 0 {
            participantsButtonClicked(NSObject())
        }
        updateParticipantsButtonText()
        updateInscriptionButton()
    }
}


 // Mark: --- MapView Delegate ---

extension MXSEventViewController {
    
    func mapView(_ mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        var region: MKCoordinateRegion = mapView.region
        region.center = (userLocation.location?.coordinate)!
        region.span = MKCoordinateSpanMake(0.4, 0.4)
        mapView.setRegion(region, animated: false)
        
        GPSLocationManager.sharedInstance.userLocation = userLocation.location
    }
    
    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Ressources.MapPinIdentifier.eventId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Ressources.MapPinIdentifier.eventId)
            pinView!.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        else {
            pinView!.annotation = annotation
        }
        
        if let aPinView = pinView {
            
            aPinView.canShowCallout = true
            aPinView.isEnabled = true
            let button = UIButton(type: UIButtonType.detailDisclosure)
            button.tintColor = Constants.MainColor.kSpecialColor
            aPinView.rightCalloutAccessoryView = button
            
            if let image = UIImage(named: event.sport.lowercased()+"PinBlanc") {
                aPinView.image = image
            }
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")
        if let image = UIImage(named: event.sport.lowercased()+"Pin") {
            view.image = image
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("Annotation unselected")
        if let image = UIImage(named: event.sport.lowercased()+"PinBlanc") {
            view.image = image
        }
    }
}
