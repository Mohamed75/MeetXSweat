//
//  UIViewController+Custom.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController






class MXSViewController: UIViewController {
    
    
    override func viewDidLoad() {
        /*
        let imageView = UIImageView(image: UIImage(named: Ressources.Images.mxslogo))
        imageView.frame = CGRect(x: 0, y: 20, width: 40, height: 40)
        imageView.contentMode = .ScaleAspectFit
        navigationItem.titleView = imageView
        */
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.view.backgroundColor = Constants.MainColor.kBackGroundColor
    }
    
    func addBarButtonItem() {
        
        navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self, action: #selector(togleMenuButton), menuIconColor: UIColor.whiteColor())
    }
    
    func addValiderButton() {
        
        let validatButton = UIButton(type: .Custom)
        validatButton.addTarget(self, action: NSSelectorFromString(Constants.SelectorsString.valider), forControlEvents: .TouchUpInside)
        validatButton.setBackgroundImage(UIImage(named: Ressources.Images.valider), forState: .Normal)
        validatButton.frame = CGRectMake(0 , 0, 30, 30)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: validatButton)
    }
    
    func validatButtonClicked(sender: AnyObject) {
        
    }
    
    func togleMenuButton() {
        
        if self.evo_drawerController!.openSide == .None {
            
            self.evo_drawerController?.openDrawerSide(DrawerSide.Left, animated: true, completion: nil)
        } else {
            self.evo_drawerController?.closeDrawerAnimated(true, completion: nil)
        }
    }
    
    func refreshView() {
        
    }
    
    func endEditing() {
        
        self.view.endEditing(true)
    }
    
    
    
    
    class func showInformationPopUp(title: String, withCancelButton: Bool, completion: (String) -> Void) {
        
        var inputTextField: UITextField?
        
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        
        if withCancelButton {
            let cancelAction: UIAlertAction = UIAlertAction(title: Strings.Alert.cancel, style: .Cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelAction)
        }
        
        let nextAction: UIAlertAction = UIAlertAction(title: Strings.Alert.ok, style: .Default) { action -> Void in
            completion((inputTextField?.text)!)
        }
        actionSheetController.addAction(nextAction)
        
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
        }
        
        getVisibleViewController().presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    class func showInformatifPopUp(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: Strings.Alert.ok, style: .Default, handler: { (UIAlertAction) in
            getVisibleViewController().dismissViewControllerAnimated(true, completion:nil)
        })
        alertController.addAction(okAction)
        
        getVisibleViewController().presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: --- Others ---
    
    class func customButton(button: UIButton) {
        
        button.backgroundColor = Constants.MainColor.kSpecialColor
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 5
    }
    
    class func underLineView(view: UIView) {
    
        let line = UIView(frame: CGRect(x: 0, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        line.backgroundColor = UIColor.blackColor()
        view.addSubview(line)
    }
    
    
    // MARK: --- Shake Device ---
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Show the AddEventViewController when the device is shaked
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            let addEventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.addEvent)
            self.evo_drawerController!.presentViewController(addEventViewController, animated: true, completion: nil)
        }
    }
}