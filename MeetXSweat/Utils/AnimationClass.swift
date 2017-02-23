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
private let fullRotation = Float(2*M_PI)

private let angle = 180.0


typealias EffectBlock = (UIView, Bool -> Void) -> ()
typealias FlipBlock = (() -> Void)



class AnimationClass {
    
    class func BounceEffect() -> EffectBlock {
        return { view, completion in
            view.transform = CGAffineTransformMakeScale(0.5, 0.5)
            
            let animationBlock = {
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: animationBlock, completion: completion)
        }
    }
    
    class func FadeOutEffect() -> EffectBlock {
        return { view, completion in
            
            let animationBlock = {
                view.alpha = 0
            }
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: animationBlock, completion: completion)
        }
    }
    
    private class func get3DTransformation(angle: Double) -> CATransform3D {
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform, CGFloat(angle * M_PI / 180.0), 0, 1, 0.0)
        
        return transform
    }
    
    class func flipAnimation(view: UIView, completion: FlipBlock?) {
        
        view.layer.transform = get3DTransformation(angle)
        
        let animationBlock = {
            view.layer.transform = CATransform3DIdentity
        }
        let endBlock: (Bool -> Void) = { (finished) -> Void in
            guard let aCompletion = completion else {
                return
            }
            aCompletion()
        }
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .TransitionNone, animations: animationBlock, completion: endBlock)
    }
    
    
    class func rotateImageToRightInfinie(view: UIView, speed: Float) {
        
        if view.layer.animationForKey(rotationRightInfiniKey) != nil {
            return
        }
        let rotationAnimation = CABasicAnimation(keyPath:zPath)
        rotationAnimation.toValue   = NSNumber(float: fullRotation)
        rotationAnimation.speed     = speed
        rotationAnimation.repeatCount = Float.infinity
        
        view.layer.addAnimation(rotationAnimation, forKey:rotationRightInfiniKey)
    }
}
