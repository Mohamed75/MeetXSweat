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
        
        let user = User.currentUser
        if user.isConnected {
            
            if self.viewControllers.count > 0 {
                
                dispatch_async(dispatch_get_main_queue()){ [weak self] in
                    guard let this = self else {
                        return
                    }
                    this.viewControllers = [MXSHomeViewController.sharedInstance]
                }
            }
            
        } else {
            
            if self.viewControllers.count > 0 {
                
                dispatch_async(dispatch_get_main_queue()){ [weak self] in
                    guard let this = self else {
                        return
                    }
                    let allLoginsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.logInId)
                    this.viewControllers = [allLoginsViewController]
                }
            }
        }
        
        super.viewDidLoad()
    }
    
    
    func getPreviousViewController() -> UIViewController {
        if let indexCurrentViewController = self.viewControllers.indexOf(self.visibleViewController!) {
            return self.viewControllers[indexCurrentViewController-1]
        }
        return UIViewController()
    }
}
