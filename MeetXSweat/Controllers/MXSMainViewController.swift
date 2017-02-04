//
//  MXSMainViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController


/**
 * This class is the default viewController of the navigationController, it will be replaced at the starting of the app by MXSFindProfileViewController or MXSAllLoginsViewController trough the UINavigationViewController viewDidLoad methode
 **/
class MXSMainViewController: MXSViewController {


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        FireBaseDataManager.sharedInstance
        ConversationsDataManager.sharedInstance
        
        MSXFindManager.sharedInstance
        
        self.evo_drawerController!.openDrawerGestureModeMask = OpenDrawerGestureMode.PanningCenterView
    }
    
    
}