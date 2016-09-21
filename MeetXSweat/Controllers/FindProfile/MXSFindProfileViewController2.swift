//
//  MXSFindProfileViewController2.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let reuseIdentifier = "MXSFindProfile2CollectionCell"


// Dummy Data
private let names = ["Tony", "Alex", "Sedik", "John", "Alcapon"]
private let lastNames = ["Montana", "LeCon", "Bendi", "Halliday", "Themaster"]
private let professions = ["Developer", "Project Manager", "Medecin", "Professeur", "Developer"]
private let sports = ["foot \ntennis", "foot \nbasket", "", "volley", "hand \nbasket"]




class MXSFindProfileViewController2: UIViewController {

    var dataArray = [Person]()
    
    // Dummy Data
    func getPerons() -> [Person] {
        
        var returnArray: [Person] = []
        
        for i in 0...4 {
            
            let person = Person()
            person.name = names[i]
            person.lastName = lastNames[i]
            person.profession = professions[i]
            person.sport = sports[i]
            returnArray.append(person)
        }
        return returnArray
    }
    
    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.dataArray = FindProfileManager.filterBy(getPerons(), filter: FindProfileManager.sharedInstance.profession)
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