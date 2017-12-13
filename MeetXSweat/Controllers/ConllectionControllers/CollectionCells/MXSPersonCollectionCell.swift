//
//  MXSFindProfile2CollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Person CollectionCell.
 
 - superClass:  UICollectionViewCell.
 */

class MXSPersonCollectionCell: UICollectionViewCell {
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var label: UILabel!
    
    
    override func prepareForReuse() {
        
        self.label.text = ""
        super.prepareForReuse()
        
        self.backgroundColor = Constants.MainColor.kBackGroundColor
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
        self.layer.cornerRadius = Constants.Cell.cornerRadius
    }
    
}
