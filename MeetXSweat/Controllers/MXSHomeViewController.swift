//
//  HomeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MXSHomeCollectionCell"

private let numberOfSections =  4
private let cell1Text = "Trouver un profil professionel"
private let cell2Text = "Trouver un sport"
private let cell3Text = "Trouver une date de disponnible"
private let cell4Text = "Trouver ce qu'il y'as autour de moi"




class MXSHomeViewController: MXSViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func loadProfileImage() {
        
        if User.currentUser.isConnected {
            
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
            profileImageView.image = UIImage(named: Ressources.Images.profilePlaceHolder)
            if let pictureUrl = User.currentUser.pictureUrl {
                
                profileImageView.af_setImageWithURL(NSURL(string: Utils.makeHttpsUrlFromString(pictureUrl))!)
            }
            profileImageView.layer.cornerRadius = 19
            profileImageView.layer.masksToBounds = true
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileRightButtonClicked)))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImageView)
        }
    }
    
    override func viewDidLoad() {
        
        self.loadProfileImage()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func profileRightButtonClicked() {
        
       NSLog("profileRightButtonClicked")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MXSHomeCollectionCell
        cell.imageView.image = UIImage(named: Ressources.Images.ProfessionalProfile)
        if indexPath.section != numberOfSections-1 {
            cell.addLine()
        }
        
        switch indexPath.section {
        case 0:
            cell.label.text = cell1Text
            break
        case 1:
            cell.label.text = cell2Text
            break
        case 2:
            cell.label.text = cell3Text
            break
        case 3:
            cell.label.text = cell4Text
            break
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            let findProfileViewController1 = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
            self.navigationController?.pushViewController(findProfileViewController1, animated: true)
            break
            
        case 1:
            let findSportViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.findSportId)
            self.navigationController?.pushViewController(findSportViewController, animated: true)
            break
            
        default:
            break
        }
    }
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height/5.5)
    }
    
}