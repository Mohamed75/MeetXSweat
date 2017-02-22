//
//  ViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import AlamofireImage


let placeHolderAttributes = [
    NSForegroundColorAttributeName: UIColor.blackColor(),
    //NSFontAttributeName : UIFont(name: "Roboto-Bold", size: 17)! // Note the !
]


class MXSAllLoginsViewController: MXSViewController {

    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    
    
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var textFieldsViewTopConstraint: NSLayoutConstraint!
    
    private var saveIniTextFieldsViewTopConstraint: CGFloat!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    private var savedTabBarController: UITabBarController!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.evo_drawerController!.openDrawerGestureModeMask = []
        googleButton.setBackgroundImage(UIImage(named: Ressources.Images.glBtn), forState: .Normal)
        
        
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.email, attributes:placeHolderAttributes)
        userNameTextField.returnKeyType = .Next
        MXSViewController.underLineView(userNameTextField)
        
        passWordTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.password, attributes:placeHolderAttributes)
        passWordTextField.returnKeyType = .Done
        MXSViewController.underLineView(passWordTextField)
        
        Utils.addTapGestureToView(view, target: self, selectorString: kEndEditingSelectorString)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        saveIniTextFieldsViewTopConstraint = textFieldsViewTopConstraint.constant
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Heigh {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name:UIKeyboardWillShowNotification, object: self.view.window)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name:UIKeyboardWillHideNotification, object: self.view.window)
        }
        
        savedTabBarController = self.tabBarController
        if (savedTabBarController != nil) {
            var frame = savedTabBarController.view.frame
            frame.size.height += 50
            savedTabBarController.view.frame = frame
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Heigh {
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
        }
        
        if (savedTabBarController != nil) {
            var frame = savedTabBarController.view.frame
            frame.size.height -= 50
            savedTabBarController.view.frame = frame
            savedTabBarController = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: --- Show/Hide keyboard ---
    
    func keyboardWillHide(sender: NSNotification) {
        
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += 50
            self.textFieldsViewTopConstraint.constant += 30
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { [weak self] () -> Void in
                    
                    guard let this = self else {
                        return
                    }
                    this.view.frame.origin.y -= 50
                    this.textFieldsViewTopConstraint.constant -= 30
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { [weak self] () -> Void in
                
                guard let this = self else {
                    return
                }
                this.view.frame.origin.y += 50 - offset.height
                this.textFieldsViewTopConstraint.constant += 30 - offset.height
            })
        }
    }
    
    
    
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        
        guard let email = userNameTextField.text where email.characters.count > 0 else {
            // alert
            return
        }
        
        guard let password = passWordTextField.text where password.characters.count > 0 else {
            // alert
            return
        }
        
        MXSActivityIndicator.startAnimating()
        User.currentUser.initFromEmailData(email, password: password, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        })
        NSLog("email account created success: %@", User.currentUser.allParams())
    }
    
    
    // MARK: --- TextFields Delegate ---
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        
        if textField == userNameTextField {
            passWordTextField.becomeFirstResponder()
        } else {
            passWordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    // MARK: --- LogIn Buttons Clicked ---
    
    @IBAction func faceBookLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeFB, viewController: self)
    }
    
    @IBAction func twitterLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeTW, viewController: self)
    }
    
    @IBAction func linkedInLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeLK, viewController: self)
    }
    
    @IBAction func googleLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeGL, viewController: self)
    }
    
    @IBAction func emailButtonClicked(sender: AnyObject) {
        
        let createAccountViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.createAccountId)
        self.navigationController?.pushViewController(createAccountViewController, animated: true)
    }
}

