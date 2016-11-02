//
//  MXSMenuViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/29/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController

private let kMenuItemsTitle = ["Home", "Messages", "Log out"]


class MXSMenuViewController: UITableViewController {
    
    var mainNavigationController: UINavigationController!
    var conversationsNavigationController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
        self.view.backgroundColor = kBackGroundColor
        
        mainNavigationController = self.evo_drawerController!.centerViewController as! UINavigationController
        
        let conversationsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.conversation, viewControllerId: Ressources.StoryBooardsIdentifiers.conversationId)
        conversationsNavigationController = UINavigationController(rootViewController: conversationsViewController)
        conversationsNavigationController.navigationBar.barTintColor = mainNavigationController.navigationBar.barTintColor
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kMenuItemsTitle.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(Ressources.CellReuseIdentifier.menu)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: Ressources.CellReuseIdentifier.menu)
        }
        cell?.textLabel?.text = kMenuItemsTitle[indexPath.row]
        cell?.backgroundColor = kBackGroundColor
        cell?.textLabel?.textColor = kDefaultTextColor
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            self.evo_drawerController!.centerViewController = mainNavigationController
            break
        case 1:
            self.evo_drawerController!.centerViewController = conversationsNavigationController
            break
        case 2:
            User.currentUser.isConnected = false
            User.currentUser.saveCustomObject()
            self.evo_drawerController?.centerViewController!.viewDidLoad()
            break
        default:
            break
        }
        self.evo_drawerController?.closeDrawerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
