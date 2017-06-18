//
//  MSXLogInManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/4/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import GoogleSignIn


enum LogInType {
    
    case logInTypeFB
    case logInTypeTW
    case logInTypeLK
    case logInTypeGL
}


class MXSLogInManager: LogInFBDelegate, LogInTWDelegate, LogInLKDelegate, LogInGoogleDelegate {

    
    static let sharedInstance = MXSLogInManager()
    
    fileprivate var controller: UIViewController!
    
    
    func logIn(_ logInType: LogInType, viewController: UIViewController) {
        
        self.controller = viewController
        
        MXSActivityIndicator.startAnimating()
        
        switch logInType {
            
        case .logInTypeFB:
            FaceBookHelper.sharedInstance.logIn(self)
        case .logInTypeTW:
            TwitterHelper.logIn(self)
        case .logInTypeLK:
            MXSActivityIndicator.stopAnimating()
            LiknedInHelper.logIn(self)
        case .logInTypeGL:
            GoogleLogInHelper.sharedInstance.logIn(self)
        }
    }
    
    // MARK: --- LogIn Helpers callBacks ---
    
    func logInFBSuccess(_ data: NSDictionary?) {
        
        guard let aData = data else {
            MXSLogInManager.endLogin(self.controller)
            return
        }
        MXSActivityIndicator.startAnimatingInView(getAppDelegateWindow())
        
        let block: CompletionSuccessBlock = { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MXSLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        }
        User.currentUser.initFromFBData(aData, completion: block)
        NSLog("facebook login success: %@", User.currentUser.allParams())
    }
    
    func logInTWSuccess(_ data: NSDictionary?) {
        
        guard let aData = data else {
            MXSLogInManager.endLogin(self.controller)
            return
        }
        
        let block: CompletionSuccessBlock = { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MXSLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        }
        User.currentUser.initFromTWData(aData, completion: block)
        NSLog("twitter login success: %@", User.currentUser.allParams())
    }
    
    func logInLKSuccess(_ data: NSDictionary?) {
        
        guard let aData = data else {
            MXSLogInManager.endLogin(self.controller)
            return
        }
        
        let block: CompletionSuccessBlock = { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MXSLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        }
        MXSActivityIndicator.startAnimating()
        User.currentUser.initFromLKData(aData, completion: block)
        NSLog("linkedIn login success: %@", User.currentUser.allParams())
    }
    
    func logInGoogleSuccess(_ data: NSDictionary?) {
        
        guard let aData = data else {
            MXSLogInManager.endLogin(self.controller)
            return
        }
        
        let block: CompletionSuccessBlock = { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MXSLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        }
        User.currentUser.initFromGoogleData(aData, completion: block)
        NSLog("google login success: %@", User.currentUser.allParams())
    }
    
    static func endLogin(_ viewController: UIViewController) {
        
        MXSActivityIndicator.stopAnimating()
        viewController.navigationController?.viewDidLoad()
        viewController.viewWillAppear(false)
        ConversationsDataManager.sharedInstance.loadData()
    }
}
