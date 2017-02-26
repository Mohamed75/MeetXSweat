//
//  MXSConversationCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 10/4/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSConversationCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var label: UILabel!
    
    
    func addLine() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height-2, width: self.frame.size.width, height: 2))
        lineView.tag = 22
        lineView.backgroundColor = UIColor.black
        self.addSubview(lineView)
    }
    
    override func prepareForReuse() {
        
        self.label.text = ""
        super.prepareForReuse()
    }
}
