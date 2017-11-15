//
//  MXSSportCollectionCell.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit



/**
 *  This class was designed and implemented to provide a Sport CollectionCell.
 
 - superClass:  UICollectionViewCell.
 */

class MXSSportCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportLabel: UILabel!
    
    var borderView: UIView!
    var lineView: UIView!
    
    fileprivate let yMargin = CGFloat(3)
    fileprivate let xMargin = CGFloat(3)
    
    func initCell() {
        
        self.backgroundColor = Constants.MainColor.kBackGroundColor
        
        borderView = UIView(frame: CGRect(x: xMargin, y: yMargin, width: self.frame.size.width-(2*xMargin), height: self.frame.size.height-(2*yMargin)))
        borderView.layer.borderColor    = UIColor.white.cgColor
        borderView.layer.borderWidth    = 1
        borderView.layer.cornerRadius   = 5
        self.insertSubview(borderView, at: 0)
        
        self.sportLabel.textColor = UIColor.white
        self.sportLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        lineView = UIView(frame: CGRect(x: xMargin, y: self.frame.size.height-45, width: self.frame.size.width-(2*xMargin), height: 2))
        lineView.backgroundColor = UIColor.white
        self.addSubview(lineView)
    }
    
    func cellSelected() {
        
        borderView.backgroundColor = Constants.MainColor.kCustomBlueColor
        borderView.layer.borderWidth    = 0
    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        borderView.backgroundColor = UIColor.clear
    }
}
