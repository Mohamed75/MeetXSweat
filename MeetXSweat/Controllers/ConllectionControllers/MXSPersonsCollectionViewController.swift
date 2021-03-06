//
//  MXSPersonCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



private let kNameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kCustomBlueColor,
    NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)
]

private let kProfessionAttributes = [
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName : UIFont.systemFont(ofSize: 14)
]

private let kCollectionViewCellHeigh: CGFloat = 60


/**
 *  This class was designed and implemented to provide a Person CollectionViewController.
 
 - superClass:  UICollectionViewController.
 - coclass      MXSFindManager, UserViewModel.
 - helper       Utils.
 */

class MXSPersonsCollectionViewController: UICollectionViewController {
    
    internal var persons: [Person]?
    var event: Event?
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Constants.MainColor.kBackGroundColor
    }
    
    
    // MARK: - *** CollectionView Delegate ***
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Ressources.CellReuseIdentifier.person, for: indexPath) as! MXSPersonCollectionCell
        
        cell.prepareForReuse()
        
        if let persons = self.persons {
            
            let person = persons[indexPath.section]
            
            let fullName = person.aFullName()
            let professionDomaine = person.professionDomaine()
            let string = NSMutableAttributedString(string: fullName + "\n" + professionDomaine)
            string.addAttributes(kNameAttributes, range: NSRange(location: 0, length: fullName.characters.count))
            if !professionDomaine.isEmpty {
                string.addAttributes(kProfessionAttributes, range: NSRange(location: fullName.characters.count, length: professionDomaine.characters.count))
            }
            cell.label.attributedText = string
            
            cell.layoutIfNeeded()
            
            if let existingUserImageView = cell.imageView.viewWithTag(33) {
                existingUserImageView.removeFromSuperview()
            }
            
            let userImageView = UIImageView(frame: CGRect(x: 10.3, y: 10.3, width: cell.imageView.frame.size.width/1.6, height: cell.imageView.frame.size.height/1.6))
            userImageView.tag = 33
            cell.imageView.addSubview(userImageView)
            
            UserViewModel.setUserImageView(userImageView, person: person)
        }
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if MXSFindManager.sharedInstance.findBy == FindBy.profile {
            
            let profileViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.profileId) as! MXSProfileViewController
            if let persons = self.persons {
                profileViewController.person = persons[indexPath.section]
            }
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    internal override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let persons = self.persons {
            return persons.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: kCollectionViewCellHeigh)
    }
    
}
