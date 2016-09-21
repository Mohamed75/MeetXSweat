//
//  UINavigationController+Connection.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



extension UINavigationController {

    public override func viewDidLoad() {
        
        if User.currentUser.isConnected {
            
            if self.viewControllers.count > 0 {
                dispatch_async(dispatch_get_main_queue()){
                   let homeViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.homeId)
                    self.viewControllers = [homeViewController]
                }
            }
            
        } else {
            
            if self.viewControllers.count > 0 {
                dispatch_async(dispatch_get_main_queue()){
                    let allLoginsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.logInId)
                    self.viewControllers = [allLoginsViewController]
                }
            }
        }
        
        super.viewDidLoad()
    }
}
