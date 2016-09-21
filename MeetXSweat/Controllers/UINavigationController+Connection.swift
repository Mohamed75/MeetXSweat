//
//  UINavigationController+Connection.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let homeViewController = UIStoryboard(name: Ressources.StoryBooards.main, bundle: nil).instantiateViewControllerWithIdentifier(Ressources.StoryBooardsIdentifiers.homeId)

private let allLoginsViewController = UIStoryboard(name: Ressources.StoryBooards.main, bundle: nil).instantiateViewControllerWithIdentifier(Ressources.StoryBooardsIdentifiers.logInId)


extension UINavigationController {

    public override func viewDidLoad() {
        
        if User.currentUser.isConnected {
            
            if self.viewControllers.count > 0 {
                dispatch_async(dispatch_get_main_queue()){
                    self.viewControllers = [homeViewController]
                }
            }
            
        } else {
            
            if self.viewControllers.count > 0 {
                dispatch_async(dispatch_get_main_queue()){
                    self.viewControllers = [allLoginsViewController]
                }
            }
        }
        
        super.viewDidLoad()
    }
}
