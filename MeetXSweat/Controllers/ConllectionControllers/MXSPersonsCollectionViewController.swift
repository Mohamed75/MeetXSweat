//
//  MXSPersonCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



private let nameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kSpecialColor,
    NSFontAttributeName : UIFont.boldSystemFontOfSize(15)
]

private let professionAttributes = [
    NSForegroundColorAttributeName: UIColor.blackColor(),
    NSFontAttributeName : UIFont.systemFontOfSize(14)
]


class MXSPersonsCollectionViewController: UICollectionViewController {
    
    var persons: [Person]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.person, forIndexPath: indexPath) as! MXSPersonCollectionCell
        
        if let persons = self.persons {
            
            let person = persons[indexPath.section]
            let text = person.name  + " " + person.lastName
            
            let string = NSMutableAttributedString(string: text + "\n" + FindProfileManager.sharedInstance.profession)
            string.addAttributes(nameAttributes, range: NSRange(location: 0,length: text.characters.count))
            if !FindProfileManager.sharedInstance.profession.isEmpty {
                string.addAttributes(professionAttributes, range: NSRange(location: text.characters.count,length: FindProfileManager.sharedInstance.profession.characters.count))
            }
            cell.label.attributedText = string
            
            cell.layoutIfNeeded()
            
            if let existingUserImageView = cell.imageView.viewWithTag(33) {
                existingUserImageView.removeFromSuperview()
            }
            
            let userImageView = UIImageView(frame: CGRect(x: 3, y: 2.5, width: cell.imageView.frame.size.width-6, height: cell.imageView.frame.size.height-6))
            userImageView.tag = 33
            cell.imageView.addSubview(userImageView)
            
            if !person.pictureUrl.isEmpty {
                userImageView.af_setImageWithURL(
                    NSURL(string: User.currentUser.pictureUrl)!,
                    placeholderImage: nil,
                    filter: nil,
                    imageTransition: .None
                )
                userImageView.layer.cornerRadius = userImageView.frame.width/2
                userImageView.clipsToBounds = true
            }
        }
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if MSXFindManager.sharedInstance.findBy == FindBy.Profile {
            
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
        
        return CGSize(width: self.view.frame.size.width, height: 60)
    }
    
}
