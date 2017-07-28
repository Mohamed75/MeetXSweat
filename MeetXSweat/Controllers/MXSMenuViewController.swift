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



/**
 *  This class was designed and implemented to provide an UITableViewController Left Menu.
 
 - superClass:  UITableViewController.
 - classdesign  Inheritance.
 - coclass      DrawerController, UserViewModel.
 - helper       Utils.
 */

class MXSMenuViewController: UITableViewController {
    
    internal var mainNavigationController: UITabBarController!
    
    internal var userView: UIImageView!
    
    
    
    // Mark: --- SetUp subView ---
    
    internal func customSectionHeader(_ pView: UIView) {
        
        for v in pView.subviews {
            v.removeFromSuperview()
        }
        
        let userPhoto = UIImageView(frame: CGRect(x: 0, y: 20, width: 80, height: 80))
        userPhoto.image = UIImage(named: Ressources.Images.userPhoto)
        userPhoto.center.x = pView.center.x
        pView.addSubview(userPhoto)
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 50, height: 50))
        userPhoto.addSubview(imageView)
        UserViewModel.setUserImageView(imageView, person: User.currentUser)
        
        let person = User.currentUser
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 110, width: 200, height: 30))
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textAlignment = .center
        pView.addSubview(nameLabel)
        nameLabel.text = " " + person.aFullName()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.textColor = Constants.MainColor.kSpecialColor
        nameLabel.sizeToFit()
        nameLabel.frame.size.width += 20
        nameLabel.center.x = pView.center.x
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        
        
        
        let professionLabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.origin.y+30, width: 200, height: 30))
        professionLabel.backgroundColor = UIColor.white
        professionLabel.textAlignment = .center
        pView.addSubview(professionLabel)
        professionLabel.text = " " + person.professionDomaine()
        professionLabel.font = UIFont.systemFont(ofSize: 16)
        professionLabel.textColor = Constants.MainColor.kDefaultTextColor
        professionLabel.sizeToFit()
        professionLabel.frame.size.width += 20
        professionLabel.center.x = pView.center.x
        professionLabel.layer.cornerRadius = 5
        professionLabel.clipsToBounds = true
        
        let profileButton = UIButton(frame: CGRect(x: imageWidth-55, y: 5, width: 40, height: 40))
        profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        profileButton.setImage(UIImage(named: Ressources.MenuImages.modifier), for: UIControlState())
        profileButton.backgroundColor = UIColor.white
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        pView.addSubview(profileButton)
    }
    
    
    
    // Mark: ---  View lifecycle ---
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle    = UITableViewCellSeparatorStyle.none
        tableView.register(UINib(nibName: "MXSMenuCellView", bundle: nil), forCellReuseIdentifier: Ressources.CellReuseIdentifier.menu)
        
        
        view.backgroundColor        = Constants.MainColor.kBackGroundColor
        
        mainNavigationController    = evo_drawerController!.centerViewController as! UITabBarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customSectionHeader(userView)
    }
    
    
    
    // Mark: --- Buttons Actions ---
    
    internal func profileButtonClicked(_ sender: AnyObject) {
        
        let profileViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.profileId) as! MXSProfileViewController
        profileViewController.person = User.currentUser
        profileViewController.editable = true
        evo_drawerController!.centerViewController = UINavigationController(rootViewController: profileViewController)
        
        evo_drawerController?.closeDrawer(animated: true, completion: nil)
    }
    
    internal func sectionHeaderClicked() {
        evo_drawerController!.centerViewController = mainNavigationController
        evo_drawerController?.closeDrawer(animated: true, completion: nil)
        dispatch_later(0.1) { [weak self] in
            
            guard let this = self else {
                return
            }
            if let firstNavigationController = this.mainNavigationController.viewControllers?.first as? UINavigationController {
                firstNavigationController.viewWillAppear(false)
                
                if let currentNavigationController = this.mainNavigationController.viewControllers?[this.mainNavigationController.selectedIndex] as? UINavigationController {
                    currentNavigationController.visibleViewController?.viewWillAppear(false)
                }
            }
        }
    }
    
    
    // Mark: --- UIScrollView Delegate ---
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
}


// Mark: --- UITableView Delegate ---

extension MXSMenuViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return imageHeight+20
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight+20))
            sectionHeader.backgroundColor = UIColor.black
            userView = UIImageView(frame: CGRect(x: 0, y: 20, width: imageWidth, height: imageHeight))
            userView.image = UIImage(named: Ressources.Images.topMap)
            sectionHeader.addSubview(userView)
            Utils.addTapGestureToView(userView, target: self, selectorString: "sectionHeaderClicked")
            customSectionHeader(userView)
            return sectionHeader
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kMenuItemsTitle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: Ressources.CellReuseIdentifier.menu) as? MXSMenuCellView
        if cell == nil {
            cell = MXSMenuCellView(style: .default, reuseIdentifier: Ressources.CellReuseIdentifier.menu)
        }
        cell?.selectionStyle    = .none
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let conversationsViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.conversation, viewControllerId: Ressources.StoryBooardsIdentifiers.conversationId)
            evo_drawerController!.centerViewController = UINavigationController(rootViewController: conversationsViewController)
            break
            
        case 1:
            if let viewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.embedSportsId) as? MXSFindCollectionViewController {
                viewController.isSweatWorking = true
                evo_drawerController!.centerViewController = UINavigationController(rootViewController: viewController)
            }
            break
            
        case 2:
            share()
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
        evo_drawerController?.closeDrawer(animated:true, completion: nil)
    }
    
    private func share() {
        
        let shareItems: [Any] = [Constants.Sharings.textToShare, Constants.Sharings.imgShare, Constants.Sharings.websiteShare]
        
        Utils.sharing(shareItems: shareItems, onController: self)
    }
}
