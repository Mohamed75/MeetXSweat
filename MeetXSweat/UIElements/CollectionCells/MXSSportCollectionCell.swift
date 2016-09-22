//
//  MXSSportCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton


class MXSSportCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var radioButton: DLRadioButton!
    
    
    func initColors() {
        let color = UIColor.redColor()
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        radioButton.multipleSelectionEnabled = true
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        
        let font = self.radioButton.titleLabel?.font
        self.radioButton.removeFromSuperview()
        
        let aRadioButton = DLRadioButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        aRadioButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        aRadioButton.titleLabel?.font = font
        self.addSubview(aRadioButton)
        aRadioButton.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: aRadioButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 10)
        let leadingConstraint = NSLayoutConstraint(item: aRadioButton, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 10)
        let trailingConstraint = NSLayoutConstraint(item: aRadioButton, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        
        self.radioButton = aRadioButton
        initColors()
        
    }
    
}
