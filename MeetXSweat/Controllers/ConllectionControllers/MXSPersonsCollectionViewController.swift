//
//  MXSPersonCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit




class MXSPersonsCollectionViewController: UICollectionViewController {
    
    var persons: [Person]?
    
    
    
    func isEmbdedInEventViewController() -> Bool {
        
        if let parentViewController = self.parentViewController where parentViewController.isKindOfClass(MXSEventViewController) {
            return true
        }
        return false
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.person, forIndexPath: indexPath) as! MXSPersonCollectionCell
        if let persons = self.persons {
            
            let person = persons[indexPath.section]
            let text = person.name  + " " + person.lastName
            cell.label.text = text + "\n" + FindProfileManager.sharedInstance.profession
        }
        cell.imageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !(isEmbdedInEventViewController() && MXSHomeViewController.sharedInstance.findBy == FindBy.Profile) {
            
            let profileViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.profileId) as! MXSProfileViewController
            if let persons = self.persons {
                profileViewController.person = persons[indexPath.section]
            }
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    internal override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let persons = self.persons {
            return persons.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cellHeight: CGFloat = 100
        if isEmbdedInEventViewController() {
            cellHeight = 60
        }
        
        return CGSize(width: self.view.frame.size.width, height: cellHeight)
    }
    
}
