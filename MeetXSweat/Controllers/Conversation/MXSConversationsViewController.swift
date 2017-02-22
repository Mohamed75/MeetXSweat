//
//  MXSConversationsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSConversationsViewController: MXSViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let conversationsCollectionViewController = self.childViewControllers.first as? MXSConversationsCollectionViewController
        conversationsCollectionViewController?.conversations = ConversationsDataManager.sharedInstance.conversations
        
        self.addBarButtonItem()
    }
    
    override func refreshView() {
        
        if let conversationsCollectionViewController = self.childViewControllers.first as? MXSConversationsCollectionViewController {
            conversationsCollectionViewController.conversations = ConversationsDataManager.sharedInstance.conversations
        }
    }
}
