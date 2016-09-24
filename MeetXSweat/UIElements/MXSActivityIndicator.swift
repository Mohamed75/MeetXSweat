//
//  MXSActivityIndicator.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let width: CGFloat = 60
private let height: CGFloat = 60


class MXSActivityIndicator: UIView {

    static let sharedInstance = MXSActivityIndicator(frame: CGRect(x: 0, y: 0, width: width, height: height))
    //var imageView: UIImageView!
    
    override init(frame: CGRect) {
        
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: Ressources.Images.clearLogo)
        super.init(frame: frame)
        super.addSubview(imageView)
        super.center = getVisibleViewController().view.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func startAnimating() {
        
        getVisibleViewController().view.addSubview(sharedInstance)
        AnimationClass.rotateImageToRightInfinie(sharedInstance, speed: 0.3)
    }
    
    class func stopAnimating() {
        
        sharedInstance.removeFromSuperview()
    }

}