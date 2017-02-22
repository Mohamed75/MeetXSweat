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
    
    static private let emptyTextField = UITextField()
    
    
    static func initPickerView(pickerView: UIPickerView, controller: UIViewController, scale: Bool) {
    
        emptyTextField.inputView = pickerView
        pickerView.delegate = controller as? UIPickerViewDelegate
        pickerView.showsSelectionIndicator = false
        
        if !scale && ScreenSize.currentHeight <= ScreenSize.iphone5Height {
            pickerView.backgroundColor = UIColor.whiteColor()
        }
        
        if (scale) {
            pickerView.transform = CGAffineTransformMakeScale(kPickerViewScale, kPickerViewScale)
        } else {
            if kPickerViewScaleWidth != 0 {
                pickerView.transform = CGAffineTransformMakeScale(kPickerViewScaleWidth, kPickerViewScaleWidth)
            }
        }
        
        if let drawerController = getAppDelegateWindow().rootViewController as? DrawerController {
            
             drawerController.drawerVisualStateBlock = { (drawerController, gestureRecognizer, value) -> Void in
                if drawerController.openSide == .Left {
                    subViewPanned(pickerView, controller: controller)
                }
             }
            
            drawerController.gestureCompletionBlock = { (drawerController, gestureRecognizer) -> Void in
                
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
                if drawerController.openSide == .None {
                    showPickerView(pickerView, controller: controller, scale: scale)
                } else {
                    subViewPanned(pickerView, controller: controller)
                }
            }
        }
    }
    
    
    static func showPickerView(pickerView: UIPickerView, controller: UIViewController, scale: Bool) {
        
        emptyTextField.becomeFirstResponder()
        controller.tabBarController?.view.addSubview(pickerView)
        
        let x = (ScreenSize.currentWidth-pickerView.frame.size.width)/2
        if (scale) {
            pickerView.frame = CGRectMake(x, ScreenSize.currentHeight - pickerView.frame.size.height - 50, pickerView.frame.size.width, pickerView.frame.size.height)
        }
        else {
            var pickerViewHeight = pickerView.frame.size.height
            if ScreenSize.currentHeight == ScreenSize.iphone4Height {
                pickerViewHeight = ScreenSize.currentHeight/2.4
            } else {
                if pickerView.subviews.count > 2 { // make sure is done juste one time
                    pickerViewHeight = pickerViewHeight - 14
                }
            }
            pickerView.frame = CGRectMake(x, ScreenSize.currentHeight - pickerViewHeight + 20, pickerView.frame.size.width, pickerViewHeight)
        }
        
        if pickerView.subviews.count > 2 {
            pickerView.subviews[2].removeFromSuperview()
            let selectorIndicator = pickerView.subviews[1]
            selectorIndicator.frame = CGRect(x: x*(1/kPickerViewScale), y: selectorIndicator.frame.origin.y, width: pickerView.frame.size.width, height: 35)
            selectorIndicator.backgroundColor = Constants.MainColor.kSpecialColorClear
            pickerView.insertSubview(selectorIndicator, atIndex: 0)
        }
        
        pickerView.selectRow(2, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
    }

    static func subViewPanned(pickerView: UIPickerView, controller: UIViewController) {
        pickerView.removeFromSuperview()
        controller.view.endEditing(true)
    }
    
}