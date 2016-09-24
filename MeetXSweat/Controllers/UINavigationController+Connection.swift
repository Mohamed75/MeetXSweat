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
                unowned let weakSelf = self
                dispatch_async(dispatch_get_main_queue()){
                    weakSelf.viewControllers = [MXSHomeViewController.sharedInstance]
                }
            }
            
        } else {
            
            if self.viewControllers.count > 0 {
                unowned let weakSelf = self
                dispatch_async(dispatch_get_main_queue()){
                    let allLoginsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.logInId)
                    weakSelf.viewControllers = [allLoginsViewController]
                }
            }
        }
        
        super.viewDidLoad()
    }
    
    
    func getPreviousViewController() -> UIViewController {
        let indexCurrentViewController = self.viewControllers.indexOf(self.visibleViewController!)
        return self.viewControllers[indexCurrentViewController!-1]
    }
}
