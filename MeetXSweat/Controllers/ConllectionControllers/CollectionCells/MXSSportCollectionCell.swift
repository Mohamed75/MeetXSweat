//
//  MXSSportCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton



/**
 *  This class was designed and implemented to provide a Sport CollectionCell.
 
 - superClass:  UICollectionViewCell.
 */

class MXSSportCollectionCell: UICollectionViewCell {
    
    /*
    @IBOutlet weak var radioButton: DLRadioButton!
    
    private let radioButtonColor = UIColor.red
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
    }*/
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportLabel: UILabel!
    
    
    fileprivate let yMargin = CGFloat(3)
    fileprivate let xMargin = CGFloat(3)
    
    func initCell() {
        
        let borderView = UIView(frame: CGRect(x: xMargin, y: yMargin, width: self.frame.size.width-(2*xMargin), height: self.frame.size.height-(2*yMargin)))
        borderView.layer.borderColor    = Constants.MainColor.kSpecialColor.cgColor
        borderView.layer.borderWidth    = 1
        borderView.layer.cornerRadius   = 5
        self.addSubview(borderView)
        
        self.sportLabel.textColor = Constants.MainColor.kSpecialColor
        self.starImageView.image = UIImage(named: Ressources.SportsImages.starUnSelected)
        
        let lineView = UIView(frame: CGRect(x: xMargin, y: self.frame.size.height-30, width: self.frame.size.width-(2*xMargin), height: 2))
        lineView.backgroundColor = Constants.MainColor.kSpecialColor
        self.addSubview(lineView)
    }
    
    func cellSelected() {
        
        self.starImageView.image = UIImage(named: Ressources.SportsImages.starSelected)
    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
    }
}
