//
//  MXSProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let nameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kSpecialColor,
    NSFontAttributeName : UIFont.boldSystemFontOfSize(17)
]

private let professionAttributes = [
    NSForegroundColorAttributeName: UIColor.blackColor(),
    NSFontAttributeName : UIFont.systemFontOfSize(16)
]




class MXSProfileViewController: MXSViewController {


    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    
    var person: Person!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !User.currentUser.pictureUrl.isEmpty {
            imageView.af_setImageWithURL(
                NSURL(string: User.currentUser.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .None
            )
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.clipsToBounds = true
        }
        
        let text = person.fullName()
        let string = NSMutableAttributedString(string: text + "\n" + FindProfileManager.sharedInstance.profession)
        string.addAttributes(nameAttributes, range: NSRange(location: 0,length: text.characters.count))
        if !FindProfileManager.sharedInstance.profession.isEmpty {
            string.addAttributes(professionAttributes, range: NSRange(location: text.characters.count,length: FindProfileManager.sharedInstance.profession.characters.count))
        }
        nameLabel.attributedText = string
        
        
        self.descriptionLabel.text = "My temporary description"
        
        if let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController {
            // should filter events personne (to be done)
            eventsCollectionViewController.events = FireBaseDataManager.sharedInstance.events
            eventsCollectionViewController.fromProfileViewController = true
        }
        contactButton.setTitleColor(Constants.MainColor.kSpecialColor, forState: .Normal)
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
