//
//  AnimationClass.swift
//  testApplicationCalendar
//
//  Created by JayT on 2016-03-06.
//  Copyright © 2016 OS-Tech. All rights reserved.
//

import UIKit

private let rotationRightInfiniKey  = "rotationRightInfini"
private let zPath                   = "transform.rotation.z"
private let fullRotation = Float(2*Double.pi)

private let angle = 180.0


typealias EffectBlock = (UIView, ((Bool) -> Swift.Void)? ) -> ()
typealias FlipBlock = (() -> Void)


/**
 *  This class was designed and implemented to provide animations helper.
 
 - classdesign  Helper.
 */

class AnimationClass {
    
    class func BounceEffect() -> EffectBlock {
        return { view, completion in
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            let animationBlock = {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: animationBlock, completion: completion)
        }
    }
    
    class func FadeOutEffect() -> EffectBlock {
        return { view, completion in
            
            let animationBlock = {
                view.alpha = 0
            }
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: animationBlock, completion: completion)
        }
    }
    
    fileprivate class func get3DTransformation(_ angle: Double) -> CATransform3D {
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform, CGFloat(angle * Double.pi / 180.0), 0, 1, 0.0)
        
        return transform
    }
    
    class func flipAnimation(_ view: UIView, completion: FlipBlock?) {
        
        view.layer.transform = get3DTransformation(angle)
        
        let animationBlock = {
            view.layer.transform = CATransform3DIdentity
        }
        let endBlock: ((Bool) -> Void) = { (finished) -> Void in
            guard let aCompletion = completion else {
                return
            }
            aCompletion()
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: animationBlock, completion: endBlock)
    }
    
    
    class func rotateImageToRightInfinie(_ view: UIView, speed: Float) {
        
        if view.layer.animation(forKey: rotationRightInfiniKey) != nil {
            return
        }
        let rotationAnimation = CABasicAnimation(keyPath:zPath)
        rotationAnimation.toValue   = NSNumber(value: fullRotation as Float)
        rotationAnimation.speed     = speed
        rotationAnimation.repeatCount = Float.infinity
        
        view.layer.add(rotationAnimation, forKey:rotationRightInfiniKey)
    }
}
