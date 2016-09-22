//
//  MXSEventsCollectionController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let reuseIdentifier = "MXSEventsCollectionCell"


class MXSEventsCollectionViewController: UICollectionViewController {
    
    var events = DummyData.getEvents()
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MXSEventsCollectionCell
        let event = self.events[indexPath.section]
        var text = ""
        if let name = event.name {
            text = name
            if let date = event.date {
                text = name + " " + date
            }
        }
        cell.label.text = text
        cell.imageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let eventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.event, viewControllerId: Ressources.StoryBooardsIdentifiers.eventId) as! MXSEventViewController
        eventViewController.event = self.events[indexPath.section]
        self.navigationController?.pushViewController(eventViewController, animated: true)
    }
    
    internal override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 60)
    }
    
}