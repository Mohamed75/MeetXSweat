//
//  UINavigationController+Connection.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController


/** This extension will replace the default MXSViewController by MXSHomeViewController or MXSAllLoginsViewController at the start app depending of the user is connected or not
 **/
extension UINavigationController {

    
    // MARK: - *** View lifecycle ***
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Custom TabBar item
        if let aTabBarController = self.tabBarController {
            
            for tab in aTabBarController.tabBar.items!
            {
                tab.image = tab.image!.withRenderingMode(.alwaysOriginal)
                tab.selectedImage = tab.selectedImage!.withRenderingMode(.alwaysOriginal)
            }
            
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:Constants.MainColor.kCustomBlueColor], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:Constants.MainColor.kTabBarItemColor], for: UIControlState())
            
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: aTabBarController.tabBar.frame.size.width, height: 1))
            lineView.backgroundColor = UIColor.white
            aTabBarController.tabBar.addSubview(lineView)
        }
        
        // Custom View
        self.view.backgroundColor = Constants.MainColor.kBackGroundColor
        
        // Custom NavigationBar
        self.navigationBar.backIndicatorImage = UIImage(named: Ressources.Images.back)?.withRenderingMode(.alwaysOriginal)
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Ressources.Images.back)?.withRenderingMode(.alwaysOriginal)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:Constants.MainColor.kTabBarItemColor]
        
        self.navigationBar.barTintColor = Constants.MainColor.kNavigationBarColor
        self.navigationBar.isTranslucent = false
        
        
        
        let user = User.currentUser
        if user.isConnected {
            
            if self.viewControllers.count > 0 {
                
                let block = { [weak self] in
                    
                    guard let this = self else {
                        return
                    }
                    
                    if let dico = UserDefaults.standard.object(forKey: "FirstTime") as? NSDictionary, (dico[user.email] as? String) == "false" {
                        
                        NSLog("Already wellcomed")
                    } else {
                        
                        let wellComeViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.wellCome, viewControllerId: Ressources.StoryBooardsIdentifiers.wellComeId)
                        this.viewControllers = [wellComeViewController]
                        
                        this.isNavigationBarHidden = false
                        this.tabBarController?.tabBar.isHidden = true
                        
                        var frame = this.tabBarController?.view.frame
                        frame?.size.height += Constants.tabBarHeight
                        this.tabBarController?.view.frame = frame!

                        return
                    }
                    
                    
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
                    
                    this.isNavigationBarHidden = false
                    this.tabBarController?.tabBar.isHidden = false
                    
                    this.evo_drawerController!.openDrawerGestureModeMask = OpenDrawerGestureMode.panningCenterView
                }
                
                DispatchQueue.main.async(execute: block)
            }
            
        } else {
            
            if self.viewControllers.count > 0 {
                
                let block = { [weak self] in
                    
                    guard let this = self else {
                        return
                    }
                    let allLoginsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.logInId)
                    this.viewControllers = [allLoginsViewController]
                    
                    this.isNavigationBarHidden = true
                    this.tabBarController?.tabBar.isHidden = true
                    
                    this.evo_drawerController!.closeDrawerGestureModeMask = CloseDrawerGestureMode.panningCenterView
                }
                DispatchQueue.main.async(execute: block)
            }
            
        }
        
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let firstViewController = self.viewControllers.first as? MXSViewController {
            
            if firstViewController is MXSFindProfileViewController {
                MXSFindManager.sharedInstance.findBy = FindBy.profile
            }
            if firstViewController is MXSFindSportViewController {
                MXSFindManager.sharedInstance.findBy = FindBy.sport
            }
            if firstViewController is MXSFindDateViewController {
                MXSFindManager.sharedInstance.findBy = FindBy.date
            }
            if firstViewController is MXSFindArroundMeViewController {
                MXSFindManager.sharedInstance.findBy = FindBy.arroundMe
            }
            if firstViewController.isViewLoaded {
               firstViewController.refreshView()
            }
        }
    }
    
    // MARK: - *** Others ***
    
    func getPreviousViewController() -> UIViewController {
        if let indexCurrentViewController = self.viewControllers.index(of: self.visibleViewController!) {
            return self.viewControllers[indexCurrentViewController-1]
        }
        return UIViewController()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
