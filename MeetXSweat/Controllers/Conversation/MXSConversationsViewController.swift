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
    
    @IBOutlet weak var topView: MXSTopView!
    
    
    
    func customizeTopViewPersons() {
        
        let person = User.currentUser
        
        self.topView.imageViewCenterConstraint.constant -= 100
        UserViewModel.setUserImageView(self.topView.imageView, person: person)
        self.topView.imageView.layer.cornerRadius = 20
        self.topView.imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        let nameLabel = UILabel(frame: CGRect(x: self.topView.center.x-55, y: 13, width: self.topView.frame.size.width/1.7, height: 30))
        nameLabel.textColor = Constants.MainColor.kCustomBlueColor
        nameLabel.text = person.aFullName()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        self.topView.addSubview(nameLabel)
        
        let professionLabel = UILabel(frame: CGRect(x: self.topView.center.x-55, y: 35, width: self.topView.frame.size.width/1.7, height: 30))
        professionLabel.textColor = UIColor.white
        professionLabel.text = person.professionDomaine()
        professionLabel.font = UIFont.systemFont(ofSize: 13)
        self.topView.addSubview(professionLabel)
        
        let dateFormatter   = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        self.topView.topLabel.text = "vu aujourd'hui à " + dateFormatter.string(from: Date())
        self.topView.topLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = Strings.NavigationTitle.conversations
        
        customizeTopViewPersons()
        
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
