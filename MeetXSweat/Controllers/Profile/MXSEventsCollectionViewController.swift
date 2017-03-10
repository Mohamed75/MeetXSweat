//
//  MXSEventsCollectionController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



class MXSEventsCollectionViewController: UICollectionViewController {
    
    var events = FireBaseDataManager.sharedInstance.events
    var fromProfileViewController = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if parent?.title == Strings.NavigationTitle.sweatWorking {
            events = MXSFindManager.filterEventsByCurrentUser()
        }
        collectionView?.reloadData()
    }
    
    
    func customizeFirstCell(_ cell: UICollectionViewCell) {
        
        let eventImageView = UIImageView(frame: CGRect(x: 35, y: 15, width: 30, height: 30))
        eventImageView.image = UIImage(named: "EventIcon")
        eventImageView.tag = 33
        cell.addSubview(eventImageView)
        
        let clockImageView = UIImageView(frame: CGRect(x: 117, y: 15, width: 30, height: 30))
        clockImageView.image = UIImage(named: "Clock")
        clockImageView.tag = 34
        cell.addSubview(clockImageView)
        
        var xParticip = 170
        var xMap = 215
        if ScreenSize.currentWidth > ScreenSize.iphone6Width {
            xParticip = 195
            xMap = 260
        }
        if ScreenSize.currentWidth == ScreenSize.iphone6Width {
            xParticip = 180
            xMap = 235
        }
        let participantImageView = UIImageView(frame: CGRect(x: xParticip, y: 15, width: 30, height: 30))
        participantImageView.image = UIImage(named: "Participants")
        participantImageView.tag = 35
        cell.addSubview(participantImageView)
        
        
        let mapView = UIImageView(frame: CGRect(x: xMap, y: 15, width: 30, height: 30))
        mapView.image = UIImage(named: "MapIcon")
        mapView.tag = 36
        cell.addSubview(mapView)
        
        var xSport = self.view.frame.size.width - 50
        if ScreenSize.currentWidth >= ScreenSize.iphone6Width {
            xSport = self.view.frame.size.width - 60
        }
        let sportImageView = UIImageView(frame: CGRect(x: xSport, y: 15, width: 30, height: 30))
        sportImageView.image = UIImage(named: "SportIcon")
        sportImageView.tag = 37
        cell.addSubview(sportImageView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Ressources.CellReuseIdentifier.event, for: indexPath) as! MXSEventsCollectionCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        for v in cell.subviews {
            if v.tag > 32 && v.tag < 38 {
                v.removeFromSuperview()
            }
        }
        cell.imageView.image = nil
        
        if indexPath.section == 0 {
            cell.label.text = ""
            customizeFirstCell(cell)
            return cell
        }
        
        let event = self.events[indexPath.section-1]
        var text = ""
        if let jour = event.getJour(), let heure = event.getHeure() {
            text = jour + "     " + heure
        }
        
        
        var mapSpace        = "    "
        var personsSpace    = "      "
        if ScreenSize.currentWidth > ScreenSize.iphone6Width {
            mapSpace = mapSpace + "      "
            personsSpace = personsSpace + "       "
        }
        if ScreenSize.currentWidth == ScreenSize.iphone6Width {
            mapSpace = mapSpace + "   "
            personsSpace = personsSpace + "   "
        }
        text = text + personsSpace + String(event.persons.count)
        
        if let coordinate = event.getCoordinate() {
            let km = GPSLocationManager.getDistanceFor(coordinate)/Constants.mToKm
            if km > 0 {
                let distance  = String(format: "%.1fKM", km)
                if distance.characters.count > 5 {
                    text = text + mapSpace + distance
                } else {
                    text = text + mapSpace + " " + distance
                }
            }
        }
        
        cell.label.text         = text
        cell.imageView.image    = UIImage(named: event.sport.lowercased())
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if MXSFindManager.sharedInstance.findBy == FindBy.profile || !fromProfileViewController {
            
            if indexPath.section > 0 {
             
                let eventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.event, viewControllerId: Ressources.StoryBooardsIdentifiers.eventId) as! MXSEventViewController
                eventViewController.event = events[indexPath.section-1]
                navigationController?.pushViewController(eventViewController, animated: true)
            }
        }
    }
    
    internal override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return events.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: 60)
    }
    
}
