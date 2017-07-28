//
//  MXSConversationsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Conversations ViewController with a ContainerView of a CollectionView.
 
 - superClass:  MXSViewController.
 */

class MXSConversationsViewController: MXSViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = Strings.NavigationTitle.conversations
        
        titleLabel.backgroundColor = Constants.MainColor.kSpecialColor
        
        if let conversationsCollectionViewController = childViewControllers.first as? MXSConversationsCollectionViewController {
            conversationsCollectionViewController.conversations = ConversationsDataManager.sharedInstance.conversations
        }
        
        
        addBarButtonItem()
    }
    
    override func refreshView() {
        
        if let conversationsCollectionViewController = childViewControllers.first as? MXSConversationsCollectionViewController {
            conversationsCollectionViewController.conversations = ConversationsDataManager.sharedInstance.conversations
            conversationsCollectionViewController.collectionView?.reloadData()
        }
    }
}
