//
//  MXSMenuViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/29/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController


private let kMenuItemsTitle = ["Mes messages", "Mes sweatworking", "Invitez des amis","Log out"]
private let kMenuItemsDesc  = ["Je construis mon réseau", "Mon historique d'activité", "J'élargie mon perimetre", "Je me déconnecte"]
private let kMenuItemsImage = ["messages", "loupe", "adduser"]

private let imageWidth  = (ScreenSize.currentWidth > ScreenSize.iphone6Width) ? ScreenSize.currentWidth-130 : (ScreenSize.currentWidth == ScreenSize.iphone6Width) ? ScreenSize.currentWidth-90 : ScreenSize.currentWidth-40
private let imageHeight: CGFloat = 180.0





class MXSMenuViewController: UITableViewController {
    
    var mainNavigationController: UITabBarController!
    
    var imageView: UIImageView!
    
    func customSectionHeader(pView: UIView) {
        
        Utils.addTapGestureToView(pView, target: self, selectorString: "sectionHeaderClicked")
        
        let userPhoto = UIImageView(frame: CGRect(x: 0, y: 20, width: 80, height: 80))
        userPhoto.image = UIImage(named: Ressources.Images.userPhoto)
        userPhoto.center.x = pView.center.x
        pView.addSubview(userPhoto)
        
        imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 50, height: 50))
        userPhoto.addSubview(imageView)
        
        let person = User.currentUser
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 110, width: 200, height: 30))
        nameLabel.backgroundColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        pView.addSubview(nameLabel)
        nameLabel.text = " " + person.aFullName()
        nameLabel.font = UIFont.boldSystemFontOfSize(17)
        nameLabel.textColor = Constants.MainColor.kSpecialColor
        nameLabel.sizeToFit()
        nameLabel.frame.size.width += 20
        nameLabel.center.x = pView.center.x
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        
        
        
        let professionLabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.origin.y+30, width: 200, height: 30))
        professionLabel.backgroundColor = UIColor.whiteColor()
        professionLabel.textAlignment = .Center
        pView.addSubview(professionLabel)
        professionLabel.text = " " + person.professionDomaine()
        professionLabel.font = UIFont.systemFontOfSize(16)
        professionLabel.textColor = Constants.MainColor.kDefaultTextColor
        professionLabel.sizeToFit()
        professionLabel.frame.size.width += 20
        professionLabel.center.x = pView.center.x
        professionLabel.layer.cornerRadius = 5
        professionLabel.clipsToBounds = true
        
        let profileButton = UIButton(frame: CGRect(x: imageWidth-55, y: 5, width: 40, height: 40))
        profileButton.addTarget(self, action: #selector(profileButtonClicked), forControlEvents: .TouchUpInside)
        profileButton.setImage(UIImage(named: Ressources.MenuImages.modifier), forState: .Normal)
        profileButton.backgroundColor = UIColor.whiteColor()
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        pView.addSubview(profileButton)
    }
    
    func profileButtonClicked(sender: AnyObject) {
        
        let profileViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.profileId) as! MXSProfileViewController
        profileViewController.person = User.currentUser
        profileViewController.editable = true
        evo_drawerController!.centerViewController = UINavigationController(rootViewController: profileViewController)
        
        evo_drawerController?.closeDrawerAnimated(true, completion: nil)
    }
    
    func sectionHeaderClicked() {
        evo_drawerController!.centerViewController = mainNavigationController
        evo_drawerController?.closeDrawerAnimated(true, completion: nil)
        dispatch_later(0.1) { [weak self] in
            
            guard let this = self else {
                return
            }
            this.mainNavigationController.viewControllers?.first?.viewWillAppear(false)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle    = UITableViewCellSeparatorStyle.None
        tableView.registerNib(UINib(nibName: "MXSMenuCellView", bundle: nil), forCellReuseIdentifier: Ressources.CellReuseIdentifier.menu)
        
        
        view.backgroundColor        = Constants.MainColor.kBackGroundColor
        
        mainNavigationController    = evo_drawerController!.centerViewController as! UITabBarController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UserViewModel.setUserImage(imageView, person: User.currentUser)
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return imageHeight+20
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier(Ressources.CellReuseIdentifier.menu) as? MXSMenuCellView
        if cell == nil {
            cell = MXSMenuCellView(style: .Default, reuseIdentifier: Ressources.CellReuseIdentifier.menu)
        }
        cell?.selectionStyle    = .None
        cell?.titleLabel.text   = kMenuItemsTitle[indexPath.row]
        if indexPath.row < kMenuItemsImage.count {
            cell?.myImageView.image = UIImage(named: kMenuItemsImage[indexPath.row])
        }
        cell?.backgroundColor       = Constants.MainColor.kBackGroundColor
        cell?.titleLabel.textColor  = Constants.MainColor.kSpecialColor
        if indexPath.row < kMenuItemsDesc.count {
            cell?.descriptionLabel.text = kMenuItemsDesc[indexPath.row]
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            let conversationsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.conversation, viewControllerId: Ressources.StoryBooardsIdentifiers.conversationId)
            evo_drawerController!.centerViewController = UINavigationController(rootViewController: conversationsViewController)
            break
        case 1:
            
            break
        case kMenuItemsTitle.count-1: // last
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
