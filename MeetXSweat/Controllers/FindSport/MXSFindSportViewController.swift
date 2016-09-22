//
//  MXSFindSportViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton


private let sports = ["RAFTING", "BOOTCAMP", "FOOT", "BASKET", "VELO", "BOX", "NATATION", "MUSCULATION", "GOLF"]

private let reuseIdentifier = "MXSSportCollectionCell"


class MXSFindSportViewController: UIViewController {
    
    
    var allSelectedRadioButtonsIndexs = [Int]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
        var sportsArray = [String]()
        for i in self.allSelectedRadioButtonsIndexs {
            sportsArray.append(sports[i])
        }
        FindSportManager.sharedInstance.sports = sportsArray
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        
        if radioButton.selected {
            allSelectedRadioButtonsIndexs.append(radioButton.tag)
        }
        else {
            let index = allSelectedRadioButtonsIndexs.indexOf(radioButton.tag)
            allSelectedRadioButtonsIndexs.removeAtIndex(index!)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MXSSportCollectionCell
        cell.initColors()
        
        let index = (indexPath.section*2)+indexPath.row
        if sports.count > (indexPath.section*2)+indexPath.row {
            cell.radioButton.setTitle(sports[index], forState: UIControlState.Normal)
        }
        cell.radioButton.tag = index
        if allSelectedRadioButtonsIndexs.contains(index) {
            cell.radioButton.selected = true
        }
        cell.radioButton.addTarget(self, action: #selector(MXSFindSportViewController.logSelectedButton), forControlEvents: UIControlEvents.TouchUpInside);
        
        return cell
    }
    
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sports.count%2 > 0 {
            if section == sports.count/2 {
                return 1
            }
        }
        return 2
    }
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (sports.count/2)+(sports.count%2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 200)
    }
    
}
