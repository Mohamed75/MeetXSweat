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


private let imageWidth  = (ScreenSize.currentWidth > ScreenSize.iphone6Width) ? ScreenSize.currentWidth-130 : (ScreenSize.currentWidth == ScreenSize.iphone6Width) ? ScreenSize.currentWidth-90 : ScreenSize.currentWidth-40
private let imageHeight: CGFloat = 170.0



class MXSMenuViewController: UITableViewController {
    
    var mainNavigationController: UITabBarController!
    var conversationsNavigationController: UINavigationController!
    
    
    var imageView: UIImageView!
    
    func customSectionHeader(view: UIView) {
        
        let userPhoto = UIImageView(frame: CGRect(x: 0, y: 20, width: 80, height: 80))
        userPhoto.image = UIImage(named: Ressources.Images.userPhoto)
        userPhoto.center.x = view.center.x
        view.addSubview(userPhoto)
        
        imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 50, height: 50))
        userPhoto.addSubview(imageView)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle    = UITableViewCellSeparatorStyle.None
    
        view.backgroundColor        = Constants.MainColor.kBackGroundColor
        
        mainNavigationController    = evo_drawerController!.centerViewController as! UITabBarController
        
        let conversationsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.conversation, viewControllerId: Ressources.StoryBooardsIdentifiers.conversationId)
        conversationsNavigationController = UINavigationController(rootViewController: conversationsViewController)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UserViewModel.setUserImage(imageView, person: User.currentUser)
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return imageHeight
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight+20))
            sectionHeader.backgroundColor = UIColor.blackColor()
            let userView = UIImageView(frame: CGRect(x: 0, y: 20, width: imageWidth, height: imageHeight))
            userView.image = UIImage(named: Ressources.Images.topMap)
            sectionHeader.addSubview(userView)
            customSectionHeader(userView)
            return sectionHeader
        }
        return nil
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
        cell?.backgroundColor = Constants.MainColor.kBackGroundColor
        cell?.textLabel?.textColor = Constants.MainColor.kDefaultTextColor
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            evo_drawerController!.centerViewController = mainNavigationController
            break
        case 1:
            evo_drawerController!.centerViewController = conversationsNavigationController
            if let conversationVC = conversationsNavigationController.viewControllers.first as? MXSViewController {
                conversationVC.refreshView()
            }
            break
        case 2:
            User.currentUser.logOut({ [weak self] (done) in
                
                guard let this = self else {
                    return
                }
                this.evo_drawerController!.centerViewController = this.mainNavigationController
                if let tabBar = this.evo_drawerController?.centerViewController as? UITabBarController {
                    tabBar.selectedViewController!.viewDidLoad()
                }
            })
            
            break
        default:
            break
        }
        evo_drawerController?.closeDrawerAnimated(true, completion: nil)
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}
