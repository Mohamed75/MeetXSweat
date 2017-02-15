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
    
    
    
    func customizeFirstCell(cell: UICollectionViewCell) {
        
        let eventImageView = UIImageView(frame: CGRect(x: 35, y: 15, width: 30, height: 30))
        eventImageView.image = UIImage(named: "EventIcon")
        cell.addSubview(eventImageView)
        
        let clockImageView = UIImageView(frame: CGRect(x: 120, y: 15, width: 30, height: 30))
        clockImageView.image = UIImage(named: "Clock")
        cell.addSubview(clockImageView)
        
        let participantImageView = UIImageView(frame: CGRect(x: 170, y: 15, width: 30, height: 30))
        participantImageView.image = UIImage(named: "Participants")
        cell.addSubview(participantImageView)
        
        let mapView = UIImageView(frame: CGRect(x: 215, y: 15, width: 30, height: 30))
        mapView.image = UIImage(named: "MapIcon")
        cell.addSubview(mapView)
        
        let sportImageView = UIImageView(frame: CGRect(x: 260, y: 15, width: 30, height: 30))
        sportImageView.image = UIImage(named: "SportIcon")
        cell.addSubview(sportImageView)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.event, forIndexPath: indexPath) as! MXSEventsCollectionCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        if indexPath.section == 0 {
            cell.label.text = ""
            customizeFirstCell(cell)
            return cell
        }
        
        let event = self.events[indexPath.section-1]
        var text = ""
        if event.date.characters.count > 1 {
            let dates = event.date.componentsSeparatedByString(" - ")
            text = dates.first! + "      " + dates.last!
        }
        text = text + "        " + String(event.persons.count)
        
        if let coordinate = event.placeMark?.coordinate {
            let km = GPSLocationManager.getDistanceFor(coordinate)/1000
            if km > 0 {
                let distance  = String(format: "%.1fKM", km)
                if distance.characters.count > 5 {
                    text = text + "    " + distance
                } else {
                    text = text + "     " + distance
                }
            }
        }
        
        cell.label.text = text
        cell.imageView.image = UIImage(named: event.sport.lowercaseString)
        
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