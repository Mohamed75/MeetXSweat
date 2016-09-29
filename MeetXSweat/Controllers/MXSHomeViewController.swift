//
//  HomeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController

enum FindBy: Int {
    case Profile
    case Sport
    case Date
    case ArroundMe
}



class MXSHomeViewController: MXSViewController {
    
    
    static let sharedInstance = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.homeId) as! MXSHomeViewController
    
    var findBy: FindBy?
    
    
    func loadProfileImage() {
        
        if User.currentUser.isConnected {
            
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
            profileImageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
            if let imageUrl = NSURL(string: Utils.makeHttpsUrlFromString(User.currentUser.pictureUrl)) {
                profileImageView.af_setImageWithURL(imageUrl)
            }
            profileImageView.layer.cornerRadius = 19
            profileImageView.layer.masksToBounds = true
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MXSHomeViewController.profileRightButtonClicked)))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImageView)
        }
    }
    
    override func viewDidLoad() {
        
        self.loadProfileImage()
        super.viewDidLoad()
        
        FireBaseDataManager.sharedInstance
        
        self.evo_drawerController!.openDrawerGestureModeMask = OpenDrawerGestureMode.PanningCenterView
        self.addBarButtonItem()
    }
    
    func profileRightButtonClicked() {
        
       NSLog("profileRightButtonClicked")
    }
    
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            let addEventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.addEvent)
            self.presentViewController(addEventViewController, animated: true, completion: nil)
        }
    }
}