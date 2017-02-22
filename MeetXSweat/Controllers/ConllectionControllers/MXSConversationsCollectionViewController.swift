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
        let conversation = self.conversations[indexPath.section]
        var text = ""
        if conversation.persons.count > 0 {
            let person1 = conversation.getFullPersons()[0]
            text = person1.name
            let person2 = conversation.getFullPersons()[1]
            text = text + " / " + person2.name
            
            cell.layoutIfNeeded()
            cell.imageView.image = UIImage(named: Ressources.Images.userSansPhoto)
            if !person1.pictureUrl.isEmpty {
                cell.imageView.af_setImageWithURL(
                    NSURL(string: person1.pictureUrl)!,
                    placeholderImage: nil,
                    filter: nil,
                    imageTransition: .None
                )
                cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
                cell.imageView.clipsToBounds = true
            }
        }
        
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
        self.navigationController?.pushViewController(chatViewController, animated: true)
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