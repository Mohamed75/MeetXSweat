//
//  UINavigationController+Connection.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



/** This extension will replace the MWSMainViewController by MXSHomeViewController or MXSAllLoginsViewController at the start app depending of the user is connected or not
 **/
extension UINavigationController {

    
    public override func viewDidLoad() {
        
        self.navigationBar.backIndicatorImage = UIImage(named: "Back")?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")?.imageWithRenderingMode(.AlwaysOriginal)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:kBackGroundColor]
        
        
        self.navigationBar.barTintColor = kNavigationBarColor
        self.navigationBar.translucent = false
        
        if let aTabBarController = self.tabBarController {
            
            for tab in aTabBarController.tabBar.items!
            {
                tab.image = tab.image!.imageWithRenderingMode(.AlwaysOriginal)
                tab.selectedImage = tab.selectedImage!.imageWithRenderingMode(.AlwaysOriginal)
            }
            
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:kSpecialColor], forState: .Selected)
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:kSpecialColorClear], forState: .Normal)
        }
        
        let user = User.currentUser
        if user.isConnected {
            
            if self.viewControllers.count > 0 {
                
                dispatch_async(dispatch_get_main_queue()){ [weak self] in
                    guard let this = self else {
                        return
                    }
                    //this.viewControllers = [MXSHomeViewController.sharedInstance]
                    let index = this.tabBarController!.selectedIndex
                    switch index {
                        
                    case 0:
                        this.viewControllers = [MXSFindProfileViewController.sharedInstance]
                    case 1:
                        this.viewControllers = [Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.findSportId)]
                    case 2:
                        this.viewControllers = [Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findDate, viewControllerId: Ressources.StoryBooardsIdentifiers.findDateId)]
                    case 3:
                        this.viewControllers = [Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findArroundMe, viewControllerId: Ressources.StoryBooardsIdentifiers.findArroundMeId)]
                    default: break
                        
                    }
                    
                    if this.tabBarController?.selectedIndex == 0 {
                        this.tabBarController?.selectedIndex = 1
                    }
                    
                    this.navigationBarHidden = false
                    this.tabBarController?.tabBar.hidden = false
                }
            }
            
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            
        } else {
            
            if self.viewControllers.count > 0 {
                
                dispatch_async(dispatch_get_main_queue()){ [weak self] in
                    guard let this = self else {
                        return
                    }
                    let allLoginsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.logInId)
                    this.viewControllers = [allLoginsViewController]
                    
                    this.navigationBarHidden = true
                    this.tabBarController?.tabBar.hidden = true
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
