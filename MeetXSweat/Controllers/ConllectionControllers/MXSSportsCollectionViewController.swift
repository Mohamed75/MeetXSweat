//
//  MXSSportsCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton



private let kNumberOffCell = 3

private let kCellWidth   = (UIScreen.main.bounds.width/3)-4
private let kCellHeight  = kCellWidth*1.16


/**
 *  This class was designed and implemented to provide a Sport CollectionViewController.
 
 - superClass:  UICollectionViewController.
 - coclass      MXSFindManager.
 - helper       Utils.
 */

class MXSSportsCollectionViewController: UICollectionViewController {

    fileprivate var allSelectedRadioButtonsIndexs = [Int]()
    
    internal var sports = FireBaseDataManager.sharedInstance.sports
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 0
        
        NotificationCenter.default.addObserver(self, selector: Constants.FBNotificationSelector.sports, name: NSNotification.Name(rawValue: Constants.FBNotificationName.sports), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.sports), object: nil)
    }
    
    
    // MARK: - *** Notifications Observer ***
    
    func selectorSportUpdated() {
        sports = FireBaseDataManager.sharedInstance.sports
        collectionView?.reloadData()
    }
    
    
    
    
    /*
    func radioButtonSelected(radioButton : DLRadioButton) {
        
        if radioButton.selected {
            allSelectedRadioButtonsIndexs.append(radioButton.tag)
        }
        else {
            if let index = allSelectedRadioButtonsIndexs.indexOf(radioButton.tag) {
                allSelectedRadioButtonsIndexs.removeAtIndex(index)
            }
        }
    }*/
    
    func validateSelections() {
        
        var sportsArray = [String]()
        for i in self.allSelectedRadioButtonsIndexs {
            sportsArray.append(sports[i])
        }
        MXSFindManager.sharedInstance.sports = sportsArray as [AnyObject]
    }
}


// MARK: - *** CollectionView Delegate ***

extension MXSSportsCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Ressources.CellReuseIdentifier.sport, for: indexPath) as! MXSSportCollectionCell
        
        let index = (indexPath.section*kNumberOffCell)+indexPath.row
        /*
         cell.initColors()
         if sports.count > (indexPath.section*2)+indexPath.row {
         cell.radioButton.setTitle(sports[index], forState: .Normal)
         cell.radioButton.setTitleColor(kDefaultTextColor, forState: .Normal)
         }
         cell.radioButton.tag = index
         if allSelectedRadioButtonsIndexs.contains(index) {
         cell.radioButton.selected = true
         }
         cell.radioButton.addTarget(self, action: #selector(MXSSportsCollectionViewController.radioButtonSelected), forControlEvents: UIControlEvents.TouchUpInside);
         cell.backgroundColor = kBackGroundColor*/
        
        cell.initCell()
        if sports.count > (indexPath.section*kNumberOffCell)+indexPath.row {
            let sportName = sports[index]
            cell.sportImageView.image   = UIImage(named: sportName.lowercased())
            cell.sportLabel.text        = sportName
        }
        if allSelectedRadioButtonsIndexs.contains(index) {
            cell.cellSelected()
        }
        
        return cell
    }
    
    
    override internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sports.count%kNumberOffCell > 0 {
            if section == sports.count/kNumberOffCell {
                return 1
            }
        }
        return kNumberOffCell
    }
    
    override internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return (sports.count/kNumberOffCell)+(sports.count%kNumberOffCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: kCellWidth, height: kCellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = (indexPath.section*kNumberOffCell)+indexPath.row
        if allSelectedRadioButtonsIndexs.contains(index) {
            if let indexArray = allSelectedRadioButtonsIndexs.index(of: index) {
                allSelectedRadioButtonsIndexs.remove(at: indexArray)
            }
        } else {
            allSelectedRadioButtonsIndexs.append(index)
        }
        self.collectionView?.reloadData()
    }
}
