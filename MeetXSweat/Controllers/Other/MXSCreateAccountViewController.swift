//
//  ViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import AlamofireImage




class MXSCreateAccountViewController: MXSViewController {
    
    
    
    @IBOutlet weak var famillyNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField:   UITextField!
    @IBOutlet weak var emailTextField:      UITextField!
    @IBOutlet weak var passWordTextField:   UITextField!
    
    
    @IBOutlet weak var widthLogoConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var validerButton:   UIButton!
    @IBOutlet weak var cancelButton:    UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        famillyNameTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.name, attributes:placeHolderAttributes)
        famillyNameTextField.returnKeyType = .Next
        MXSViewController.underLineView(famillyNameTextField)
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.lastName, attributes:placeHolderAttributes)
        lastNameTextField.returnKeyType = .Next
        MXSViewController.underLineView(lastNameTextField)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.email, attributes:placeHolderAttributes)
        emailTextField.returnKeyType = .Next
        MXSViewController.underLineView(emailTextField)
        
        passWordTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.password, attributes:placeHolderAttributes)
        passWordTextField.returnKeyType = .Done
        MXSViewController.underLineView(passWordTextField)
        
        
        if UIScreen.mainScreen().bounds.size.height == 480 { //iPhone 4
            widthLogoConstraint.constant = 0
        }
        
        MXSViewController.customButton(validerButton)
        MXSViewController.customButton(cancelButton)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func vailderButtonClicked(sender: AnyObject) {
        
        guard let name = famillyNameTextField.text where name.characters.count > 0 else {
            // alert
            return
        }
        
        guard let lastName = lastNameTextField.text where lastName.characters.count > 0 else {
            // alert
            return
        }
        
        guard let email = emailTextField.text where email.characters.count > 0 else {
            // alert
            return
        }
        
        guard let password = passWordTextField.text where password.characters.count > 0 else {
            // alert
            return
        }
        
        
        User.currentUser.createFromEmailData(email, password: password, name: name, lastName: lastName, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this)
            }
        })
        NSLog("email account created success: %@", User.currentUser.allParams())
    }
    
    @IBAction func annulerButtonClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: --- TextFields Delegate ---
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        
        switch textField {
        /*case userNameTextField:
            famillyNameTextField.becomeFirstResponder()*/
        case famillyNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passWordTextField.becomeFirstResponder()
        case passWordTextField:
            passWordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}

