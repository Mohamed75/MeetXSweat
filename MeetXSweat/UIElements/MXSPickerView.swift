//
//  MXSPickerView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController

private let kPickerViewScale        = (((ScreenSize.currentHeight/ScreenSize.iphone4Height)-1)*2)+1
private let kPickerViewScaleWidth   = (((ScreenSize.currentWidth/ScreenSize.iphone45Width)-1)*2)+1



class MXSPickerView {
    
    static fileprivate let emptyTextField = UITextField()
    
    static fileprivate var hightResized = false
    
    
    static func initPickerView(_ pickerView: UIPickerView, controller: UIViewController, scale: Bool) {
    
        hightResized = false
        
        emptyTextField.inputView = pickerView
        pickerView.delegate = controller as? UIPickerViewDelegate
        pickerView.showsSelectionIndicator = false
        
        if !scale && ScreenSize.currentHeight <= ScreenSize.iphone5Height {
            pickerView.backgroundColor = UIColor.white
        }
        
        if (scale) {
            pickerView.transform = CGAffineTransform(scaleX: kPickerViewScale, y: kPickerViewScale)
        } else {
            if kPickerViewScaleWidth != 0 && kPickerViewScaleWidth-0.15 > 1 {
                pickerView.transform = CGAffineTransform(scaleX: kPickerViewScaleWidth-0.15, y: kPickerViewScaleWidth-0.15)
            }
        }
        
        if let drawerController = getAppDelegateWindow().rootViewController as? DrawerController {
            
             drawerController.drawerVisualStateBlock = { (drawerController, gestureRecognizer, value) -> Void in
                if drawerController.openSide == .left {
                    subViewPanned(pickerView, controller: controller)
                }
             }
            
            drawerController.gestureCompletionBlock = { (drawerController, gestureRecognizer) -> Void in
                
                let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: drawerController.view)
                if fabs(velocity.y) > fabs(velocity.x) {
                    return
                }
                
                if let tabBarController = controller.tabBarController {
                    if tabBarController.selectedIndex != 0 {
                        return
                    }
                    if let navigationController = tabBarController.viewControllers![tabBarController.selectedIndex] as? UINavigationController {
                        if navigationController.viewControllers.count > 1 {
                            return
                        }
                    }
                }
                if drawerController.openSide == .none {
                    showPickerView(pickerView, controller: controller, scale: scale)
                } else {
                    subViewPanned(pickerView, controller: controller)
                }
            }
        }
    }
    
    
    static func showPickerView(_ pickerView: UIPickerView, controller: UIViewController, scale: Bool) {
        
        emptyTextField.becomeFirstResponder()
        
        if let aTabBarController = controller.tabBarController {
            aTabBarController.view.addSubview(pickerView)
        } else {
            controller.view.addSubview(pickerView)
        }
        
        var pickerViewHeight = pickerView.frame.size.height
        let x = (ScreenSize.currentWidth-pickerView.frame.size.width)/2
        if (scale) {
            pickerView.frame = CGRect(x: x, y: ScreenSize.currentHeight - pickerViewHeight - 50, width: pickerView.frame.size.width, height: pickerViewHeight)
        }
        else {
            
            if ScreenSize.currentHeight == ScreenSize.iphone4Height {
                pickerViewHeight = ScreenSize.currentHeight/2.4
            } else {
                if !hightResized { // make sure is done juste one time
                    pickerViewHeight = pickerViewHeight - 14
                    hightResized = true
                }
            }
            pickerView.frame = CGRect(x: x, y: ScreenSize.currentHeight - pickerViewHeight + 20, width: pickerView.frame.size.width, height: pickerViewHeight)
        }
        
        // custom indecator cell color
        if pickerView.subviews.count > 2 {
            
            pickerView.subviews[2].removeFromSuperview()
            let selectorIndicator = pickerView.subviews[1]
            
            var specialHeight: CGFloat = 35
            if !scale {
                if Utils.isIOSVersionGReaterThan(version: 10.0) {
                    specialHeight = 28
                }
            }
            selectorIndicator.frame = CGRect(x: x*(1/kPickerViewScale), y: selectorIndicator.frame.origin.y, width: pickerView.frame.size.width, height: specialHeight)
            selectorIndicator.backgroundColor = Constants.MainColor.kSpecialColorClear
            pickerView.insertSubview(selectorIndicator, at: 0)
            
        } else {
            let selectorIndicator = pickerView.subviews.first
            selectorIndicator?.backgroundColor = Constants.MainColor.kSpecialColorClear
        }
        
        pickerView.selectRow(2, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
    }
    

    static func subViewPanned(_ pickerView: UIPickerView, controller: UIViewController) {
        pickerView.removeFromSuperview()
        controller.view.endEditing(true)
    }
    
}
