//
//  MXSTuttorialCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/10/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Tuttorial CollectionCell.
 
 - superClass:  UICollectionViewCell.
 */

class MXSTuttorialCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var bottomImageView: UIImageView!
    @IBOutlet internal weak var label: UILabel!
    @IBOutlet internal weak var titleLabel: UILabel!
    
    func initCell() {
        
        self.label.numberOfLines = 0
        self.label.textColor = UIColor.white
        self.label.font = Constants.Font.kBoldFontBig
        
        self.bottomImageView.image = UIImage(named: "TuttorialBottom")
        self.titleLabel.text = ""
        self.titleLabel.font = Constants.Font.kBoldFontMax
        
        self.viewWithTag(3)?.addSubview(self.label)
    }
    
    override func prepareForReuse() {
        
        self.label.text = ""
        super.prepareForReuse()
    }
}
