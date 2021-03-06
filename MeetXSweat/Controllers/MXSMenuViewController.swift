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
private let kMenuItemsImage = ["messages", "loupe", "adduser", "logout"]

private let kImageWidth  = (ScreenSize.currentWidth > ScreenSize.iphone6Width) ? ScreenSize.currentWidth-130 : (ScreenSize.currentWidth == ScreenSize.iphone6Width) ? ScreenSize.currentWidth-90 : ScreenSize.currentWidth-40
private let kMapImageHeight: CGFloat = 140.0
private let kHeaderTableViewHeight: CGFloat = kMapImageHeight + 80


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
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - *** SetUp subView ***
    
    internal func customSectionHeader(_ pView: UIView, _ superView: UIView) {
        
        for v in pView.subviews {
            v.removeFromSuperview()
        }
        
        let imageView = UserImageView.addImageView(frame: CGRect(x: 20, y: 40, width: 200, height: 200), toView: pView)
        UserViewModel.setUserImageView(imageView, person: User.currentUser)
        /*
        let person = User.currentUser
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 110, width: 200, height: 30))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textAlignment = .center
        pView.addSubview(nameLabel)
        nameLabel.text = " " + person.aFullName()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.textColor = UIColor.white
        nameLabel.sizeToFit()
        nameLabel.frame.size.width += 20
        nameLabel.center.x = pView.center.x
        nameLabel.layer.cornerRadius = Constants.Cell.cornerRadius
        nameLabel.clipsToBounds = true
        
        
        
        let professionLabel = UILabel(frame: CGRect(x: -20, y: nameLabel.frame.origin.y+30, width: 240, height: 30))
        professionLabel.backgroundColor = UIColor.clear
        professionLabel.textAlignment = .center
        pView.addSubview(professionLabel)
        professionLabel.text = " " + person.professionDomaine()
        professionLabel.font = UIFont.systemFont(ofSize: 16)
        professionLabel.textColor = UIColor.white
        professionLabel.center.x = pView.center.x
        professionLabel.layer.cornerRadius = Constants.Cell.cornerRadius
        professionLabel.clipsToBounds = true
        */
        let profileButton = UIButton(frame: CGRect(x: kImageWidth-55, y: 30, width: 30, height: 30))
        profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        //profileButton.setImage(UIImage(named: Ressources.MenuImages.modifier), for: UIControlState())
        profileButton.setBackgroundImage(UIImage(named: Ressources.MenuImages.modifier), for: UIControlState())
        profileButton.backgroundColor = UIColor.clear
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        superView.addSubview(profileButton)
    }
    
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle    = UITableViewCellSeparatorStyle.none
        tableView.register(UINib(nibName: "MXSMenuCellView", bundle: nil), forCellReuseIdentifier: Ressources.CellReuseIdentifier.menu)
        
        
        view.backgroundColor        = Constants.MainColor.kBackGroundColor
        
        mainNavigationController    = evo_drawerController!.centerViewController as! UITabBarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //customSectionHeader(userView)
    }
    
    
    
    // MARK: - *** Buttons Actions ***
    
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
        let closure = { [weak self] in
            
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
        dispatch_later(0.1, closure: closure)
    }
    
    
    // MARK: - *** UIScrollView Delegate ***
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
}


// MARK: - *** UITableView Delegate ***

extension MXSMenuViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return kHeaderTableViewHeight
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: kImageWidth, height: kHeaderTableViewHeight))
            sectionHeader.backgroundColor = UIColor.black
            userView = UIImageView(frame: CGRect(x: 0, y: 20, width: kImageWidth, height: kMapImageHeight))
            userView.image = UIImage(named: Ressources.Images.topMap)
            sectionHeader.addSubview(userView)
            Utils.addTapGestureToView(sectionHeader, target: self, selectorString: "sectionHeaderClicked")
            customSectionHeader(userView, sectionHeader)
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
        
        cell?.titleLabel.text   = kMenuItemsTitle[indexPath.row]
        if indexPath.row < kMenuItemsImage.count {
            cell?.myImageView.image = UIImage(named: kMenuItemsImage[indexPath.row])
        }
        if indexPath.row < kMenuItemsDesc.count {
            cell?.descriptionLabel.text = kMenuItemsDesc[indexPath.row]
        }
        
        cell?.backgroundColor       = Constants.MainColor.kBackGroundColor
        
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
