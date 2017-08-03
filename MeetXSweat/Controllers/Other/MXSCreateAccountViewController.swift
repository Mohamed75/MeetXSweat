//
//  ViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import AlamofireImage


/**
 *  This class was designed and implemented to provide a Create Account ViewController.
 
 - superClass:  MXSViewController.
 - helper       Utils.
 */

class MXSCreateAccountViewController: MXSViewController {
    
    
    
    @IBOutlet weak var famillyNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField:   UITextField!
    @IBOutlet weak var emailTextField:      UITextField!
    @IBOutlet weak var passWordTextField:   UITextField!
    
    
    @IBOutlet weak var widthLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLogoConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var validerButton:   UIButton!
    @IBOutlet weak var cancelButton:    UIButton!
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        famillyNameTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.name, attributes:Constants.placeHolderAttributes)
        famillyNameTextField.returnKeyType = .next
        MXSViewController.underLineView(famillyNameTextField)
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.lastName, attributes:Constants.placeHolderAttributes)
        lastNameTextField.returnKeyType = .next
        MXSViewController.underLineView(lastNameTextField)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.email, attributes:Constants.placeHolderAttributes)
        emailTextField.returnKeyType = .next
        MXSViewController.underLineView(emailTextField)
        
        passWordTextField.attributedPlaceholder = NSAttributedString(string: Strings.Account.password, attributes:Constants.placeHolderAttributes)
        passWordTextField.returnKeyType = .done
        MXSViewController.underLineView(passWordTextField)
        
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height { //iPhone 4
            widthLogoConstraint.constant  = 70
        } else if ScreenSize.currentHeight > ScreenSize.iphone5Height {
            widthLogoConstraint.constant  = 160
            bottomLogoConstraint.constant = 60
        }else {
            widthLogoConstraint.constant  = 120
            bottomLogoConstraint.constant = 40
        }
        
        Utils.addTapGestureToView(view, target: self, selectorString: kEndEditingSelectorString)
        
        MXSViewController.customButton(validerButton)
        MXSViewController.customButton(cancelButton)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - *** Button Actions ***
    
    @IBAction func vailderButtonClicked(_ sender: AnyObject) {
        
        guard let name = famillyNameTextField.text, name.characters.count > 0 else {
            MXSViewController.showInformatifPopUp(Strings.Alert.fillAllFieldsMessage)
            return
        }
        
        guard let lastName = lastNameTextField.text, lastName.characters.count > 0 else {
            MXSViewController.showInformatifPopUp(Strings.Alert.fillAllFieldsMessage)
            return
        }
        
        guard let email = emailTextField.text, email.characters.count > 0 else {
            MXSViewController.showInformatifPopUp(Strings.Alert.fillAllFieldsMessage)
            return
        }
        
        guard let password = passWordTextField.text, password.characters.count > 0 else {
            MXSViewController.showInformatifPopUp(Strings.Alert.fillAllFieldsMessage)
            return
        }
        
        guard let emailValidation = emailTextField.text, emailValidation.isValidEmail else {
            MXSViewController.showInformatifPopUp(Strings.Alert.wrongEmailMesssage)
            return
        }
        
        MXSActivityIndicator.startAnimating()
        let completion: CompletionSuccessBlock = { [weak self] (done) in
            
            guard let this = self else {
                MXSActivityIndicator.stopAnimating()
                return
            }
            if done {
                MXSLogInManager.endLogin(this)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        }
        User.currentUser.createFromEmailData(email, password: password, name: name, lastName: lastName, completion: completion)
        NSLog("email account created success: %@", User.currentUser.allParams())
    }
    
    @IBAction func annulerButtonClicked(_ sender: AnyObject) {
        
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    
    // MARK: - *** TextFields Delegate ***
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {   //delegate method
        
        switch textField {
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

