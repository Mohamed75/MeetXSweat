//
//  MXSHomeCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/19/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

class MXSHomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet internal weak var imageView: UIImageView!
    @IBOutlet internal weak var label: UILabel!
    
    
    func addLine() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height-2, width: self.frame.size.width, height: 2))
        lineView.tag = 22
        lineView.backgroundColor = UIColor.blackColor()
        self.addSubview(lineView)
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
    }
    
}
