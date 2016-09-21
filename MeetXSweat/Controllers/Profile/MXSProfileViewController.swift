//
//  MXSProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

class MXSProfileViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sportsLabel: UILabel!
    
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
        
        self.sportsLabel.text = person.sport
    }
    
    
    @IBAction func ContacterButtonClicked(sender: AnyObject) {
        
    }
}
