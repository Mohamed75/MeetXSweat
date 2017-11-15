//
//  MXSActivityIndicator.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let kWidth: CGFloat  = 60
private let kHeight: CGFloat = 60

private let kAnimationSpeed: Float  = 0.3


/**
 *  This class was designed and implemented to provide a ActivityIndicator view.
 
 - superClass:  UIView.
 - classdesign  Singleton.
 - helper       AnimationClass.
 */

class MXSActivityIndicator: UIView {

    static let sharedInstance = MXSActivityIndicator(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
    
    // MARK: - *** Initialization ***
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let imageView   = UIImageView(frame: frame)
        imageView.image = UIImage(named: Ressources.Images.mxslogo)
        super.addSubview(imageView)
        super.center = getVisibleViewController().view.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - *** Start/Stop Animation ***
    
    class func startAnimating() {
        
        let animationBlock = {
            getVisibleViewController().view.addSubview(sharedInstance)
            AnimationClass.rotateImageToRightInfinie(sharedInstance, speed: kAnimationSpeed)
        }
        DispatchQueue.main.async(execute: animationBlock)
    }
    
    class func startAnimatingInView(_ view: UIView) {
        
        let animationBlock = {
            view.addSubview(sharedInstance)
            AnimationClass.rotateImageToRightInfinie(sharedInstance, speed: kAnimationSpeed)
        }
        DispatchQueue.main.async(execute: animationBlock)
    }
    
    class func stopAnimating() {
        
        let block = {
            sharedInstance.layer.removeAllAnimations()
            sharedInstance.removeFromSuperview()
        }
        DispatchQueue.main.async(execute: block)
    }

}
