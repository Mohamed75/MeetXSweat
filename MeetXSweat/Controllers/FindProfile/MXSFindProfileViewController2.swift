//
//  MXSFindProfileViewController2.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let reuseIdentifier = "MXSFindProfile2CollectionCell"



class MXSFindProfileViewController2: UIViewController {

    var dataArray = [Person]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.dataArray = FindProfileManager.filterBy(DummyData.getPerons(), filter: FindProfileManager.sharedInstance.profession)
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MXSFindProfile2CollectionCell
        let person = self.dataArray[indexPath.section]
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let profileViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.profileId) as! MXSProfileViewController
        profileViewController.person = self.dataArray[indexPath.section]
        self.navigationController?.pushViewController(profileViewController, animated: false)
    }
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 100)
    }
    
}