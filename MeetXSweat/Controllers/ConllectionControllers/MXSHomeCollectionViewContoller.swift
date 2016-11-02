//
//  MXSHomeCollectionViewContoller.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit







class MXSHomeCollectionViewContoller: UICollectionViewController {


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.home, forIndexPath: indexPath) as! MXSHomeCollectionCell
        cell.imageView.image = UIImage(named: Ressources.Images.ProfessionalProfile)
        if indexPath.section != Strings.Home.numberOfSections-1 {
            cell.addLine()
        }
        
        switch indexPath.section {
        case 0:
            cell.label.text = Strings.Home.cell1Text
            break
        case 1:
            cell.label.text = Strings.Home.cell2Text
            break
        case 2:
            cell.label.text = Strings.Home.cell3Text
            break
        case 3:
            cell.label.text = Strings.Home.cell4Text
            break
        default:
            break
        }
        
        cell.label.textColor = kDefaultTextColor
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            let findProfileViewController1 = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
            self.navigationController?.pushViewController(findProfileViewController1, animated: true)
            (self.parentViewController as! MXSHomeViewController).findBy = FindBy.Profile
            break
            
        case 1:
            let findSportViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.findSportId)
            self.navigationController?.pushViewController(findSportViewController, animated: true)
            (self.parentViewController as! MXSHomeViewController).findBy = FindBy.Sport
            break
            
        case 2:
            let findDateViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findDate, viewControllerId: Ressources.StoryBooardsIdentifiers.findDateId)
            self.navigationController?.pushViewController(findDateViewController, animated: true)
            (self.parentViewController as! MXSHomeViewController).findBy = FindBy.Date
            break
        case 3:
            let findArroundMeViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findArroundMe, viewControllerId: Ressources.StoryBooardsIdentifiers.findArroundMeId)
            self.navigationController?.pushViewController(findArroundMeViewController, animated: true)
            (self.parentViewController as! MXSHomeViewController).findBy = FindBy.ArroundMe
            break
            
        default:
            break
        }
    }
    
    internal override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Strings.Home.numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height/4.5)
    }
}
