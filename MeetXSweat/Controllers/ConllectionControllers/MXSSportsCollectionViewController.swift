//
//  MXSSportsCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton



private let numberOffCell = 3

private let cellWidth   = (UIScreen.mainScreen().bounds.width/3)-4
private let cellHeight  = cellWidth*1.16



class MXSSportsCollectionViewController: UICollectionViewController {

    private var allSelectedRadioButtonsIndexs = [Int]()
    
    private var sports = FireBaseDataManager.sharedInstance.sports
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.sports, name: Constants.FBNotificationName.sports, object: nil)
    }
    
    // Mark: --- Notifications Observer ---
    func selectorSportUpdated() {
        sports = FireBaseDataManager.sharedInstance.sports
        self.collectionView?.reloadData()
    }
    
    
    // Mark: --- collectionView Delegate ---
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.sport, forIndexPath: indexPath) as! MXSSportCollectionCell
        
        let index = (indexPath.section*numberOffCell)+indexPath.row
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
        if sports.count > (indexPath.section*numberOffCell)+indexPath.row {
            let sportName = sports[index]
            cell.sportImageView.image   = UIImage(named: sportName.lowercaseString)
            cell.sportLabel.text        = sportName
        }
        if allSelectedRadioButtonsIndexs.contains(index) {
            cell.cellSelected()
        }
        
        return cell
    }
    
    
    override internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sports.count%numberOffCell > 0 {
            if section == sports.count/numberOffCell {
                return 1
            }
        }
        return numberOffCell
    }
    
    override internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return (sports.count/numberOffCell)+(sports.count%numberOffCell)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        let index = (indexPath.section*numberOffCell)+indexPath.row
        if allSelectedRadioButtonsIndexs.contains(index) {
            if let indexArray = allSelectedRadioButtonsIndexs.indexOf(index) {
                allSelectedRadioButtonsIndexs.removeAtIndex(indexArray)
            }
        } else {
            allSelectedRadioButtonsIndexs.append(index)
        }
        self.collectionView?.reloadData()
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
        FindSportManager.sharedInstance.sports = sportsArray
    }
}