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
        var text = ""
        if let name = person.name {
            text = name
            if let lastName = person.lastName {
                text = name + " " + lastName
            }
        }
        self.nameLabel.text = text + "\n" + FindProfileManager.sharedInstance.profession
        
        self.descriptionLabel.text = "My temporary description"
        
        if let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController {
            // should filter events personne (to be done)
            eventsCollectionViewController.events = DummyData.getEvents()
        }
    }
    
    
    @IBAction func ContacterButtonClicked(sender: AnyObject) {
        
    }
}
