//
//  MXSEventsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import MapKit



private let kInscriptionButtonText  = "JE PARTICIPE A L'EVENT"
private let kParticipantsButtonText = "VOIR LES PROFILS PRO"


/**
 *  This class was designed and implemented to provide an Event ViewController.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MXSCalendarViewController.
 - helper       Utils.
 */

class MXSEventViewController: MXSViewController {
    
    internal var event: Event!
    
    @IBOutlet weak var topView: MXSTopView!
    @IBOutlet weak var eventIconView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var participantsButton: UIButton!
    @IBOutlet weak var inscriptionButton: UIButton!
    
    @IBOutlet weak var participantsImageView: UIImageView!
    
    @IBOutlet internal weak var topCellLabel: UILabel!
    @IBOutlet internal weak var sportLabel: UILabel!
    
    
    
    private func addOverlay() {
        
        let overlay = MKTileOverlay(urlTemplate: Constants.URLS.mapTemplate)
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
    }
    
    private func customButton(button: UIButton, title: String) {
        
        button.layer.borderColor    = UIColor.white.cgColor
        button.layer.borderWidth    = 1
        button.layer.cornerRadius   = Constants.Cell.cornerRadius
        button.backgroundColor = Constants.MainColor.kCustomBlueColor
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle(title, for: UIControlState())
    }
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = Strings.NavigationTitle.event
        
        self.topView.topLabel.text = self.event.sport.uppercased()
        
        customizeEventCell(self.eventIconView)
        
        topCellLabel.textColor = UIColor.white
        sportLabel.textColor = UIColor.white
        
        eventView.layer.borderColor     = UIColor.white.cgColor
        eventView.layer.borderWidth     = 1
        eventView.layer.cornerRadius    = Constants.Cell.cornerRadius
        
        customButton(button: inscriptionButton, title: kInscriptionButtonText)
        customButton(button: participantsButton, title: kParticipantsButtonText)
        
        updateParticipantsLabelText()
        updateInscriptionButton()
        
        
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
            participantsImageView.isHidden = true
        }
    }
    
    private func updateParticipantsLabelText() {
        
        topCellLabel.text = "     " + textForEventCell(event: self.event, isEventView: true)

        var sportName = event.sport
        if sportName.characters.count < 5 {
            sportName = sportName + "   "
        }
        if ScreenSize.currentWidth >= ScreenSize.iphone6Width {
            sportName = sportName + "    "
        }
        sportLabel.text = sportName
    }
    
    private func updateInscriptionButton() {
        
        if event.isCurrentPersonAlreadyIn() {
            inscriptionButton.isEnabled = false
            inscriptionButton.alpha = 0.4
        }
    }
    
    
    // MARK: - *** Button Actions ***
    
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
                    personsCollectionViewController.event = this.event
                    viewController.topView.topLabel.text = this.event.sport.uppercased()
                    if let jour = this.event.getJour(), let heure = this.event.getHeure() {
                        viewController.topView.topLabel.text = jour + " à " + heure
                    }
                    personsCollectionViewController.persons = this.event.getFullPersons()
                    personsCollectionViewController.collectionView?.reloadData()
                }
            })
        }
    }
    
    @IBAction func inscriptionButtonClicked(_ sender: AnyObject) {
        event.addCurrentUserToEvent()
        
        let eventValidationViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.event, viewControllerId: Ressources.StoryBooardsIdentifiers.eventValidationId) as! MXSEventValidationViewController
        eventValidationViewController.event = self.event
        self.navigationController?.pushViewController(eventValidationViewController, animated: true)
        
        updateParticipantsLabelText()
        updateInscriptionButton()
    }
}


// MARK: - ***  MapView Delegate ***

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
        
        if let userLocation = GPSLocationManager.sharedInstance.userLocation {
            guard !(annotation.coordinate.latitude == userLocation.coordinate.latitude && annotation.coordinate.longitude == userLocation.coordinate.longitude) else {
                return nil
            }
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
            button.tintColor = Constants.MainColor.kCustomBlueColor
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
