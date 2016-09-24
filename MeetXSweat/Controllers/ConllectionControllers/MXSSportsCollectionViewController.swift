//
//  MXSSportsCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton






class MXSSportsCollectionViewController: UICollectionViewController {

    var allSelectedRadioButtonsIndexs = [Int]()
    
    var sports = DummyData.getSports()
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Ressources.CellReuseIdentifier.sport, forIndexPath: indexPath) as! MXSSportCollectionCell
        cell.initColors()
        
        let index = (indexPath.section*2)+indexPath.row
        if sports.count > (indexPath.section*2)+indexPath.row {
            cell.radioButton.setTitle(sports[index], forState: UIControlState.Normal)
        }
        cell.radioButton.tag = index
        if allSelectedRadioButtonsIndexs.contains(index) {
            cell.radioButton.selected = true
        }
        cell.radioButton.addTarget(self, action: #selector(MXSSportsCollectionViewController.radioButtonSelected), forControlEvents: UIControlEvents.TouchUpInside);
        
        return cell
    }
    
    
    override internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sports.count%2 > 0 {
            if section == sports.count/2 {
                return 1
            }
        }
        return 2
    }
    
    override internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (sports.count/2)+(sports.count%2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 50)
    }
    
    
    func radioButtonSelected(radioButton : DLRadioButton) {
        
        if radioButton.selected {
            allSelectedRadioButtonsIndexs.append(radioButton.tag)
        }
        else {
            let index = allSelectedRadioButtonsIndexs.indexOf(radioButton.tag)
            allSelectedRadioButtonsIndexs.removeAtIndex(index!)
        }
    }
    
    func validateSelections() {
        
        var sportsArray = [String]()
        for i in self.allSelectedRadioButtonsIndexs {
            sportsArray.append(sports[i])
        }
        FindSportManager.sharedInstance.sports = sportsArray
    }
}