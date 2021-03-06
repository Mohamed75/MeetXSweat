//
//  MXSConversationsCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let kNameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kCustomBlueColor,
    NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)
]

private let kCollectionViewCellHeigh: CGFloat = 60

/**
 *  This class was designed and implemented to provide a Sport CollectionViewController.
 
 - superClass:  UICollectionViewController.
 - coclass      MXSFindManager, UserViewModel.
 - helper       Utils.
 */

class MXSConversationsCollectionViewController: UICollectionViewController {
    
    internal var conversations: [Conversation]!
    
    
    // MARK: - *** CollectionView Delegate ***
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Ressources.CellReuseIdentifier.conversation, for: indexPath) as! MXSConversationCollectionCell
        
        cell.prepareForReuse()
        
        var imagePerson = Person()
        let conversation = conversations[indexPath.section]
        var text = ""
        if conversation.persons.count > 0 {
            if let person1 = conversation.getFullPersons().first {
                text = person1.name
                if person1.email != User.currentUser.email {
                    imagePerson = person1
                }
            }
            if let person2 = conversation.getFullPersons().last {
                text = text + " / " + person2.name
                if person2.email != User.currentUser.email {
                    imagePerson = person2
                }
            }
        }
        
        
        cell.layoutIfNeeded()
        
        let userImageView = UIImageView(frame: CGRect(x: 9, y: 9, width: cell.imageView.frame.size.width-18, height: cell.imageView.frame.size.height-18))
        userImageView.tag = 33
        cell.imageView.addSubview(userImageView)
        
        UserViewModel.setUserImageView(userImageView, person: imagePerson)
        
        
        let string = NSMutableAttributedString(string: text)
        string.addAttributes(kNameAttributes, range: NSRange(location: 0, length: text.characters.count))
        cell.label.attributedText = string
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let chatViewController = ChatViewController()
        chatViewController.conversation = conversations[indexPath.section]
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    internal override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.conversations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: kCollectionViewCellHeigh)
    }
    
}
