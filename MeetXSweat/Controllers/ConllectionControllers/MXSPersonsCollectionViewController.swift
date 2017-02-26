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
    NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)
]

private let professionAttributes = [
    NSForegroundColorAttributeName: UIColor.black,
    NSFontAttributeName : UIFont.systemFont(ofSize: 14)
]


class MXSPersonsCollectionViewController: UICollectionViewController {
    
    var persons: [Person]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Ressources.CellReuseIdentifier.person, for: indexPath) as! MXSPersonCollectionCell
        
        if let persons = self.persons {
            
            let person = persons[indexPath.section]
            
            let text = person.aFullName()
            let professionDomaine = person.professionDomaine()
            let string = NSMutableAttributedString(string: text + "\n" + professionDomaine)
            string.addAttributes(nameAttributes, range: NSRange(location: 0, length: text.characters.count))
            if !professionDomaine.isEmpty {
                string.addAttributes(professionAttributes, range: NSRange(location: text.characters.count, length: professionDomaine.characters.count))
            }
            cell.label.attributedText = string
            
            cell.layoutIfNeeded()
            
            if let existingUserImageView = cell.imageView.viewWithTag(33) {
                existingUserImageView.removeFromSuperview()
            }
            
            let userImageView = UIImageView(frame: CGRect(x: 9, y: 9, width: cell.imageView.frame.size.width-18, height: cell.imageView.frame.size.height-18))
            userImageView.tag = 33
            cell.imageView.addSubview(userImageView)
            
            UserViewModel.setUserImageView(userImageView, person: person)
        }
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if MSXFindManager.sharedInstance.findBy == FindBy.profile {
            
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
        
        return CGSize(width: self.view.frame.size.width, height: 60)
    }
    
}
