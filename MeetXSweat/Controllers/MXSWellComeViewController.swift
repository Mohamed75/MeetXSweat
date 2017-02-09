//
//  MXSWellComeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSWellComeViewController: MXSViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var userImageWidthConst: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        nameLabel.text = User.currentUser.fullName()
        
        self.title = Ressources.NavigationTitle.wellCome
        
        addValiderButton()
        
        userImageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !User.currentUser.pictureUrl.isEmpty {
            userImageView.af_setImageWithURL(
                NSURL(string: User.currentUser.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .None
            )
            //userImageWidthConst.constant -= 10
            //userImageView.layer.cornerRadius = (userImageView.frame.width-10)/2
            userImageView.layer.cornerRadius = userImageView.frame.width/2
            userImageView.clipsToBounds = true
        }
    }
    
    
    override func validatButtonClicked(sender: AnyObject) {
        
    }
    
}