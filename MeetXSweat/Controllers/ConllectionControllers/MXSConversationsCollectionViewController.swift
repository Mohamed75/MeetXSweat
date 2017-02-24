//
//  MXSConversationsCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let nameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kSpecialColor,
    NSFontAttributeName : UIFont.boldSystemFontOfSize(17)
]


class MXSConversationsCollectionViewController: UICollectionViewController {
    
    var conversations: [Conversation]!
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.conversation, forIndexPath: indexPath) as! MXSConversationCollectionCell
        
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
        UserViewModel.setUserImage(cell.imageView, person: imagePerson)
        
        
        let string = NSMutableAttributedString(string: text)
        string.addAttributes(nameAttributes, range: NSRange(location: 0, length: text.characters.count))
        cell.label.attributedText = string
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let chatViewController = ChatViewController()
        chatViewController.conversation = conversations[indexPath.section]
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    internal override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.conversations.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 60)
    }
    
}