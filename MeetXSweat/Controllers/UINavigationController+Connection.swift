//
//  UINavigationController+Connection.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController


/** This extension will replace the MWSMainViewController by MXSHomeViewController or MXSAllLoginsViewController at the start app depending of the user is connected or not
 **/
extension UINavigationController {

    
    public override func viewDidLoad() {
        
        self.navigationBar.backIndicatorImage = UIImage(named: Ressources.Images.back)?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Ressources.Images.back)?.imageWithRenderingMode(.AlwaysOriginal)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:Constants.MainColor.kBackGroundColor]
        
        self.view.backgroundColor = Constants.MainColor.kBackGroundColor
        
        self.navigationBar.barTintColor = Constants.MainColor.kNavigationBarColor
        self.navigationBar.translucent = false
        
        if let aTabBarController = self.tabBarController {
            
            for tab in aTabBarController.tabBar.items!
            {
                tab.image = tab.image!.imageWithRenderingMode(.AlwaysOriginal)
                tab.selectedImage = tab.selectedImage!.imageWithRenderingMode(.AlwaysOriginal)
            }
            
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:Constants.MainColor.kSpecialColor], forState: .Selected)
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:Constants.MainColor.kSpecialColorClear], forState: .Normal)
        }
        
        let user = User.currentUser
        if user.isConnected {
            
            if self.viewControllers.count > 0 {
                
                let block = { [weak self] in
                    
                    guard let this = self else {
                        return
                    }
                    
                    if let dico = NSUserDefaults.standardUserDefaults().objectForKey("FirstTime") as? NSDictionary where (dico[user.email] as? String) == "false" {
                        
                        NSLog("Alleready wellcomed")
                    } else {
                        
                        let wellComeViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.wellCome, viewControllerId: Ressources.StoryBooardsIdentifiers.wellComeId)
                        this.viewControllers = [wellComeViewController]
                        
                        this.navigationBarHidden = false
                        this.tabBarController?.tabBar.hidden = true
                        
                        UIApplication.sharedApplication().statusBarStyle = .LightContent
                        
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
                        GPSLocationManager.sharedInstance.startUserLocation()
                        this.tabBarController?.selectedIndex = 1
                    }
                    
                    this.navigationBarHidden = false
                    this.tabBarController?.tabBar.hidden = false
                    
                    this.evo_drawerController!.openDrawerGestureModeMask = OpenDrawerGestureMode.PanningCenterView
                    
                    UIApplication.sharedApplication().statusBarStyle = .LightContent
                }
                
                dispatch_async(dispatch_get_main_queue(), block)
            }
            
        } else {
            
            if self.viewControllers.count > 0 {
                
                let block = { [weak self] in
                    
                    guard let this = self else {
                        return
                    }
                    let allLoginsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.logInId)
                    this.viewControllers = [allLoginsViewController]
                    
                    this.navigationBarHidden = true
                    this.tabBarController?.tabBar.hidden = true
                    
                    this.evo_drawerController!.closeDrawerGestureModeMask = CloseDrawerGestureMode.PanningCenterView
                }
                dispatch_async(dispatch_get_main_queue(), block)
            }
            
        }
        
        super.viewDidLoad()
    }
    
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let firstViewController = self.viewControllers.first as? MXSViewController {
            
            if firstViewController is MXSFindProfileViewController {
                MSXFindManager.sharedInstance.findBy = FindBy.Profile
            }
            if firstViewController is MXSFindSportViewController {
                MSXFindManager.sharedInstance.findBy = FindBy.Sport
            }
            if firstViewController is MXSFindDateViewController {
                MSXFindManager.sharedInstance.findBy = FindBy.Date
            }
            if firstViewController is MXSFindArroundMeViewController {
                MSXFindManager.sharedInstance.findBy = FindBy.ArroundMe
            }
            if firstViewController.isViewLoaded() {
               firstViewController.refreshView()
            }
        }
    }
    
    
    func getPreviousViewController() -> UIViewController {
        if let indexCurrentViewController = self.viewControllers.indexOf(self.visibleViewController!) {
            return self.viewControllers[indexCurrentViewController-1]
        }
        return UIViewController()
    }
}
