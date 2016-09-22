//
//  MXSPersonCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MXSPersonCollectionCell"


class MXSPersonsCollectionViewController: UICollectionViewController {
    
    var persons = FindProfileManager.filterBy(DummyData.getPerons(), filter: FindProfileManager.sharedInstance.profession)
    
    
    
    func isEmbdedInEventViewController() -> Bool {
        
        if let parentViewController = self.parentViewController where parentViewController.isKindOfClass(MXSEventViewController) {
            return true
        }
        return false
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MXSPersonCollectionCell
        let person = self.persons[indexPath.section]
        var text = ""
        if let name = person.name {
            text = name
            if let lastName = person.lastName {
                text = name + " " + lastName
            }
        }
        cell.label.text = text + "\n" + FindProfileManager.sharedInstance.profession
        cell.imageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !isEmbdedInEventViewController() {
            
            let profileViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.profileId) as! MXSProfileViewController
            profileViewController.person = self.persons[indexPath.section]
            self.navigationController?.pushViewController(profileViewController, animated: false)
        }
    }
    
    internal override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return persons.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cellHeight: CGFloat = 100
        if isEmbdedInEventViewController() {
            cellHeight = 60
        }
        
        return CGSize(width: self.view.frame.size.width, height: cellHeight)
    }
    
}
