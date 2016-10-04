//
//  MXSSportCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton


private let radioButtonColor = UIColor.redColor()


class MXSSportCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var radioButton: DLRadioButton!
    
    
    func initColors() {
        
        radioButton.iconColor = radioButtonColor
        radioButton.indicatorColor = radioButtonColor
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        radioButton.multipleSelectionEnabled = true
        radioButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        
        let font = self.radioButton.titleLabel?.font
        self.radioButton.removeFromSuperview()
        
        let aRadioButton = DLRadioButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        aRadioButton.titleLabel?.font = font
        self.addSubview(aRadioButton)
        aRadioButton.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: aRadioButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 10)
        let leadingConstraint = NSLayoutConstraint(item: aRadioButton, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 20)
        let trailingConstraint = NSLayoutConstraint(item: aRadioButton, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        
        self.radioButton = aRadioButton
    }
    
}
