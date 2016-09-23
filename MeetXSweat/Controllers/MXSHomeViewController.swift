//
//  HomeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit




class MXSHomeViewController: MXSViewController {
    
    
    
    func loadProfileImage() {
        
        if User.currentUser.isConnected {
            
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
            profileImageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
            if let pictureUrl = User.currentUser.pictureUrl {
                
                profileImageView.af_setImageWithURL(NSURL(string: Utils.makeHttpsUrlFromString(pictureUrl))!)
            }
            profileImageView.layer.cornerRadius = 19
            profileImageView.layer.masksToBounds = true
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileRightButtonClicked)))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImageView)
        }
    }
    
    override func viewDidLoad() {
        
        self.loadProfileImage()
        super.viewDidLoad()
    }
    
    func profileRightButtonClicked() {
        
       NSLog("profileRightButtonClicked")
    }
    
}