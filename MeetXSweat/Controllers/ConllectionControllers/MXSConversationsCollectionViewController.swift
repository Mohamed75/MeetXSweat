//
//  MXSConversationsCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



class MXSConversationsCollectionViewController: UICollectionViewController {
    
    var conversations: [Conversation]!
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.conversation, forIndexPath: indexPath) as! MXSConversationCollectionCell
        let conversation = self.conversations[indexPath.section]
        var text = ""
        if conversation.persons?.count > 0 {
            let person1 = conversation.persons![0]
            text = person1.name
            let person2 = conversation.persons![1]
            text = text + " / " + person2.name
        }
        cell.label.text = text
        //cell.imageView.image = UIImage(named: Ressources.Images.event)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let chatViewController = ChatViewController()
        chatViewController.conversation = conversations[indexPath.row]
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