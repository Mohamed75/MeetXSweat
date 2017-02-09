//
//  MXSPickerView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController

private let kPickerViewScale        = (((UIScreen.mainScreen().bounds.size.height/480)-1)*2)+1
private let kPickerViewScaleWidth   = (((UIScreen.mainScreen().bounds.size.width/320)-1)*2)+1

class MXSPickerView {
    
    static let emptyTextField = UITextField()
    
    static func initPickerView(pickerView: UIPickerView, controller: UIViewController, scale: Bool) {
    
        emptyTextField.inputView = pickerView
        pickerView.delegate = controller as? UIPickerViewDelegate
        pickerView.showsSelectionIndicator = false
        
        if !scale && UIScreen.mainScreen().bounds.size.height == 480 { //iPhone 4
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
            /*
             drawerController.drawerVisualStateBlock = { (drawerController, gestureRecognizer, value) -> Void in
             if drawerController.openSide == .Left {
             self.subViewPanned()
             }
             }*/
            
            drawerController.gestureCompletionBlock = { (drawerController, gestureRecognizer) -> Void in
                
                if controller.tabBarController?.selectedIndex != 0 {
                    return
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
        
        let x = (UIScreen.mainScreen().bounds.size.width-pickerView.frame.size.width)/2
        if (scale) {
            pickerView.frame = CGRectMake(x, UIScreen.mainScreen().bounds.size.height - pickerView.frame.size.height - 50, pickerView.frame.size.width, pickerView.frame.size.height)
        }
        else {
            var pickerViewHeight = pickerView.frame.size.height
            if UIScreen.mainScreen().bounds.size.height == 480 {
                pickerViewHeight = UIScreen.mainScreen().bounds.size.height/2.4
            } else {
                if pickerView.subviews.count > 2 { // make sure is done juste one time
                    pickerViewHeight = pickerViewHeight - 14
                }
            }
            pickerView.frame = CGRectMake(x, UIScreen.mainScreen().bounds.size.height - pickerViewHeight + 20, pickerView.frame.size.width, pickerViewHeight)
        }
        
        if pickerView.subviews.count > 2 {
            pickerView.subviews[2].removeFromSuperview()
            let selectorIndicator = pickerView.subviews[1]
            selectorIndicator.frame = CGRect(x: x*(1/kPickerViewScale), y: selectorIndicator.frame.origin.y, width: pickerView.frame.size.width, height: 35)
            selectorIndicator.backgroundColor = kSpecialColor
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