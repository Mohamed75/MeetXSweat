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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = Constants.MainColor.kBackGroundColor
    }
    
    func addBarButtonItem() {
        
        navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self, action: #selector(togleMenuButton), menuIconColor: UIColor.white)
    }
    
    func addValiderButton() {
        
        let validatButton = UIButton(type: .custom)
        validatButton.addTarget(self, action: NSSelectorFromString(Constants.SelectorsString.valider), for: .touchUpInside)
        validatButton.setBackgroundImage(UIImage(named: Ressources.Images.valider), for: UIControlState())
        validatButton.frame = CGRect(x: 0 , y: 0, width: 30, height: 30)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: validatButton)
    }
    
    func validatButtonClicked(_ sender: AnyObject) {
        
    }
    
    func togleMenuButton() {
        
        if evo_drawerController!.openSide == .none {
            
            evo_drawerController?.openDrawerSide(DrawerSide.left, animated: true, completion: nil)
        } else {
            evo_drawerController?.closeDrawer(animated: true, completion: nil)
        }
    }
    
    func refreshView() {
        
    }
    
    func endEditing() {
        
        view.endEditing(true)
    }
    
    
    
    
    class func showInformationPopUp(_ title: String, withCancelButton: Bool, completion: @escaping (String) -> Void) {
        
        var inputTextField: UITextField?
        
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        if withCancelButton {
            let cancelAction: UIAlertAction = UIAlertAction(title: Strings.Alert.cancel, style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelAction)
        }
        
        let nextAction: UIAlertAction = UIAlertAction(title: Strings.Alert.ok, style: .default) { action -> Void in
            completion((inputTextField?.text)!)
        }
        actionSheetController.addAction(nextAction)
        
        actionSheetController.addTextField { textField -> Void in
            inputTextField = textField
        }
        
        getVisibleViewController().present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    class func showInformatifPopUp(_ message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Strings.Alert.ok, style: .default, handler: { (UIAlertAction) in
            getVisibleViewController().dismiss(animated: true, completion:nil)
        })
        alertController.addAction(okAction)
        
        getVisibleViewController().present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: --- Others ---
    
    class func customButton(_ button: UIButton) {
        
        button.backgroundColor = Constants.MainColor.kSpecialColor
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.layer.cornerRadius = 5
    }
    
    class func underLineView(_ view: UIView) {
    
        let line = UIView(frame: CGRect(x: 0, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        line.backgroundColor = UIColor.black
        view.addSubview(line)
    }
    
    
    // MARK: --- Shake Device ---
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    // Show the AddEventViewController when the device is shaked
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let addEventViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.addEvent)
            evo_drawerController!.present(addEventViewController, animated: true, completion: nil)
        }
    }
}
