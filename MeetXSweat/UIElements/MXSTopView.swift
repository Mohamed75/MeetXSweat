//
//  MXSTopView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 11/15/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let kTopImageViewConstraint: CGFloat    = 20
private let kToptitleLabelConstraint: CGFloat   = 30


class MXSTopView: UIView {

    var imageView: UIImageView!
    var topLabel: UILabel!
    
    
    
    // MARK: - *** Initialization ***
    
    override func draw(_ rect: CGRect) {

        imageView = UIImageView(image: UIImage(named: "SportIcon"))
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: kTopImageViewConstraint)
        let centerConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let aspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1.0 / 1.0, constant: 0)
        
        self.addConstraints([topConstraint, centerConstraint, widthConstraint, aspectRatioConstraint])
        
        topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: 40))
        topLabel.textColor = UIColor.white
        self.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topLabelConstraint = NSLayoutConstraint(item: topLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: kToptitleLabelConstraint)
        let centerLabelConstraint = NSLayoutConstraint(item: topLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        self.addConstraints([topLabelConstraint, centerLabelConstraint])
    }
    
    
    
    
}
