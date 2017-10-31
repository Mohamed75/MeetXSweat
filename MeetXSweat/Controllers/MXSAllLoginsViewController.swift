//
//  ViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import AlamofireImage


private let kButtonCornerRadius: CGFloat = 3

/**
 *  This class was designed and implemented to setUp an allLoginsViewController.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MXSLogInManager.
 - helper       Utils.
 */

class MXSAllLoginsViewController: MXSViewController {

    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    
    
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var textFieldsViewTopConstraint: NSLayoutConstraint!
    
    fileprivate var saveIniTextFieldsViewTopConstraint: CGFloat!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    

    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.evo_drawerController!.openDrawerGestureModeMask = []
        googleButton.setBackgroundImage(UIImage(named: Ressources.Images.glBtn), for: UIControlState())
        
        faceBookButton.layer.cornerRadius = kButtonCornerRadius
        faceBookButton.clipsToBounds = true
        twitterButton.layer.cornerRadius = kButtonCornerRadius
        twitterButton.clipsToBounds = true
        googleButton.layer.cornerRadius = kButtonCornerRadius
        googleButton.clipsToBounds = true
        linkedInButton.layer.cornerRadius = kButtonCornerRadius
        linkedInButton.clipsToBounds = true
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.email, attributes:Constants.placeHolderAttributes)
        userNameTextField.returnKeyType = .next
        MXSViewController.underLineView(userNameTextField)
        
        passWordTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.password, attributes:Constants.placeHolderAttributes)
        passWordTextField.returnKeyType = .done
        MXSViewController.underLineView(passWordTextField)
        
        Utils.addTapGestureToView(view, target: self, selectorString: kEndEditingSelectorString)
        
        isTabBarEtendedView = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        saveIniTextFieldsViewTopConstraint = textFieldsViewTopConstraint.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height {
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - *** Show/Hide keyboard ***
    
    func keyboardWillHide(_ sender: Notification) {
        
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += Constants.tabBarHeight
            self.textFieldsViewTopConstraint.constant += 30
        }
    }
    
    func keyboardWillShow(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                    
                    guard let this = self else {
                        return
                    }
                    this.view.frame.origin.y -= Constants.tabBarHeight
                    this.textFieldsViewTopConstraint.constant -= 30
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                
                guard let this = self else {
                    return
                }
                this.view.frame.origin.y += Constants.tabBarHeight - offset.height
                this.textFieldsViewTopConstraint.constant += 30 - offset.height
            })
        }
    }
    
    
    // MARK: - *** Buttons Actions ***
    
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        
        guard let email = userNameTextField.text, email.characters.count > 0 else {
            // alert
            return
        }
        
        guard let password = passWordTextField.text, password.characters.count > 0 else {
            // alert
            return
        }
        
        MXSActivityIndicator.startAnimating()
        let completion: CompletionSuccessBlock = { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MXSLogInManager.endLogin(this)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        }
        User.currentUser.initFromEmailData(email, password: password, completion: completion)
        NSLog("email account created success: %@", User.currentUser.allParams())
    }
    
    
    // MARK: - *** TextFields Delegate ***
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {   //delegate method
        
        if textField == userNameTextField {
            passWordTextField.becomeFirstResponder()
        } else {
            passWordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    // MARK: - *** LogIn Buttons Clicked ***
    
    @IBAction func faceBookLoginButtonClicked() {
        
        MXSLogInManager.sharedInstance.logIn(.logInTypeFB, viewController: self)
    }
    
    @IBAction func twitterLoginButtonClicked() {
        
        MXSLogInManager.sharedInstance.logIn(.logInTypeTW, viewController: self)
    }
    
    @IBAction func linkedInLoginButtonClicked() {
        
        MXSLogInManager.sharedInstance.logIn(.logInTypeLK, viewController: self)
    }
    
    @IBAction func googleLoginButtonClicked() {
        
        MXSLogInManager.sharedInstance.logIn(.logInTypeGL, viewController: self)
    }
    
    @IBAction func emailButtonClicked(_ sender: AnyObject) {
        
        let createAccountViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.main, viewControllerId: Ressources.StoryBooardsIdentifiers.createAccountId)
        self.navigationController?.pushViewController(createAccountViewController, animated: true)
    }
}

