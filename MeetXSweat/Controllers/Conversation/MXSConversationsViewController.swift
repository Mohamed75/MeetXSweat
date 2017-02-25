//
//  MXSConversationsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSConversationsViewController: MXSViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = Strings.NavigationTitle.conversations
        
        titleLabel.backgroundColor = Constants.MainColor.kSpecialColor
        
        let conversationsCollectionViewController = childViewControllers.first as? MXSConversationsCollectionViewController
        conversationsCollectionViewController?.conversations = ConversationsDataManager.sharedInstance.conversations
        
        addBarButtonItem()
    }
    
    override func refreshView() {
        
        if let conversationsCollectionViewController = childViewControllers.first as? MXSConversationsCollectionViewController {
            conversationsCollectionViewController.conversations = ConversationsDataManager.sharedInstance.conversations
            conversationsCollectionViewController.collectionView?.reloadData()
        }
    }
}
