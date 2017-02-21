//
//  MXSEventsCollectionController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



class MXSEventsCollectionViewController: UICollectionViewController {
    
    var events: [Event]!
    var fromProfileViewController = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }
    
    
    func customizeFirstCell(cell: UICollectionViewCell) {
        
        let eventImageView = UIImageView(frame: CGRect(x: 35, y: 15, width: 30, height: 30))
        eventImageView.image = UIImage(named: "EventIcon")
        eventImageView.tag = 33
        cell.addSubview(eventImageView)
        
        let clockImageView = UIImageView(frame: CGRect(x: 117, y: 15, width: 30, height: 30))
        clockImageView.image = UIImage(named: "Clock")
        clockImageView.tag = 34
        cell.addSubview(clockImageView)
        
        var xParticip = 170
        if UIScreen.mainScreen().bounds.width > 375 {
            xParticip = 195
        }
        if UIScreen.mainScreen().bounds.width == 375 {
            xParticip = 180
        }
        let participantImageView = UIImageView(frame: CGRect(x: xParticip, y: 15, width: 30, height: 30))
        participantImageView.image = UIImage(named: "Participants")
        participantImageView.tag = 35
        cell.addSubview(participantImageView)
        
        var xMap = 215
        if UIScreen.mainScreen().bounds.width > 375 {
            xMap = 260
        }
        if UIScreen.mainScreen().bounds.width == 375 {
            xMap = 235
        }
        let mapView = UIImageView(frame: CGRect(x: xMap, y: 15, width: 30, height: 30))
        mapView.image = UIImage(named: "MapIcon")
        mapView.tag = 36
        cell.addSubview(mapView)
        
        var xSport = self.view.frame.size.width - 50
        if UIScreen.mainScreen().bounds.width >= 375 {
            xSport = self.view.frame.size.width - 60
        }
        let sportImageView = UIImageView(frame: CGRect(x: xSport, y: 15, width: 30, height: 30))
        sportImageView.image = UIImage(named: "SportIcon")
        sportImageView.tag = 37
        cell.addSubview(sportImageView)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.event, forIndexPath: indexPath) as! MXSEventsCollectionCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
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
        if let jour = event.getJour(), heure = event.getHeure() {
            text = jour + "      " + heure
        }
        
        
        var mapSpace        = "    "
        var personsSpace    = "        "
        if UIScreen.mainScreen().bounds.width > 375 {
            mapSpace = mapSpace + "      "
            personsSpace = personsSpace + "       "
        }
        if UIScreen.mainScreen().bounds.width == 375 {
            mapSpace = mapSpace + "   "
            personsSpace = personsSpace + "   "
        }
        text = text + personsSpace + String(event.persons.count)
        
        if let coordinate = event.getCoordinate() {
            let km = GPSLocationManager.getDistanceFor(coordinate)/1000
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
        cell.imageView.image    = UIImage(named: event.sport.lowercaseString)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if MSXFindManager.sharedInstance.findBy == FindBy.Profile || !fromProfileViewController {
            
            if indexPath.section > 0 {
             
                let eventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.event, viewControllerId: Ressources.StoryBooardsIdentifiers.eventId) as! MXSEventViewController
                eventViewController.event = self.events[indexPath.section-1]
                self.navigationController?.pushViewController(eventViewController, animated: true)
            }
        }
    }
    
    internal override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.events.count+1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 60)
    }
    
}