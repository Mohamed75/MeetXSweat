//
//  MXSMenuCellView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/24/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Menu TableViewCell.
 
 - superClass:  UITableViewCell.
 */

class MXSMenuCellView: UITableViewCell {

    @IBOutlet internal weak var myImageView: UIImageView!
    @IBOutlet internal weak var titleLabel: UILabel!
    @IBOutlet internal weak var descriptionLabel: UILabel!
    
    // MARK: - *** Initialization ***
    
    override func draw(_ rect: CGRect) {
        
        self.selectionStyle    = .none
        
        self.titleLabel.textColor  = Constants.MainColor.kCustomBlueColor
        self.titleLabel.font = Constants.Font.kBoldFont
        self.descriptionLabel.textColor = UIColor.white
    }
}
