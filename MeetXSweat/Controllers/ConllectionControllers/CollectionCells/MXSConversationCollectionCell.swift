//
//  MXSConversationCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


/**
 *  This class was designed and implemented to provide a Conversation CollectionCell.
 
 - superClass:  UICollectionViewCell.
 */

class MXSConversationCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var label: UILabel!
    
    
    override func prepareForReuse() {
        
        self.label.text = ""
        super.prepareForReuse()
    }
}
