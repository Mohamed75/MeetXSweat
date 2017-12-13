
//
//  MXSEventsCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Event CollectionCell.
 
 - superClass:  UICollectionViewCell.
 */

class MXSEventsCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var label: UILabel!
    @IBOutlet internal weak var imageViewTraillingConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        
        self.label.text = ""
        super.prepareForReuse()
        
        if ScreenSize.currentWidth < ScreenSize.iphone6Width {
            imageViewTraillingConstraint.constant = 15
        }
    }
}
