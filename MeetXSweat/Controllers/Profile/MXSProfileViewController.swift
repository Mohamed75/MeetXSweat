//
//  MXSProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



class MXSProfileViewController: MXSViewController {


    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var person: Person!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
        
        self.nameLabel.text = person.fullName() + "\n" + FindProfileManager.sharedInstance.profession
        
        self.descriptionLabel.text = "My temporary description"
        
        if let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController {
            // should filter events personne (to be done)
            eventsCollectionViewController.events = FireBaseDataManager.sharedInstance.events
        }
    }
    
    
    @IBAction func contacterButtonClicked(sender: AnyObject) {
        
        
        let between:[Person] = [User.currentUser, self.person]
        let conversation: Conversation!
        
        
        let chatViewController = ChatViewController()
        
        if let aConversation = ConversationsDataManager.sharedInstance.getConversationBetweenPersons(between) {
            conversation = aConversation
        } else {
           conversation = Conversation()
        }
        conversation.persons = between
        chatViewController.conversation = conversation
        self.navigationController?.pushViewController(chatViewController, animated: true)
        //self.presentViewController(chatViewController, animated: true, completion: nil)
    }
}
