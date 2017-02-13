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


class MSXLogInManager: LogInFBDelegate, LogInTWDelegate, LogInLKDelegate, LogInGoogleDelegate {

    
    static let sharedInstance = MSXLogInManager()
    
    private var controller: UIViewController!
    
    
    func logIn(logInType: LogInType, viewController: UIViewController) {
        
        self.controller = viewController
        
        MXSActivityIndicator.startAnimating()
        
        switch logInType {
            
        case .logInTypeFB:
            FaceBookHelper.sharedInstance.logIn(self)
        case .logInTypeTW:
            TwitterHelper.logIn(self)
        case .logInTypeLK:
            LiknedInHelper.logIn(self)
        case .logInTypeGL:
            GoogleLogInHelper.sharedInstance.logIn(self)
        }
    }
    
    // MARK: --- LogIn Helpers callBacks ---
    
    func logInFBSuccess(data: NSDictionary?) {
        
        guard let aData = data else {
            MSXLogInManager.endLogin(self.controller)
            return
        }
        User.currentUser.initFromFBData(aData, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        })
        NSLog("facebook login success: %@", User.currentUser.allParams())
    }
    
    func logInTWSuccess(data: NSDictionary?) {
        
        guard let aData = data else {
            MSXLogInManager.endLogin(self.controller)
            return
        }
        User.currentUser.initFromTWData(aData, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        })
        NSLog("twitter login success: %@", User.currentUser.allParams())
    }
    
    func logInLKSuccess(data: NSDictionary?) {
        
        guard let aData = data else {
            MSXLogInManager.endLogin(self.controller)
            return
        }
        User.currentUser.initFromLKData(aData, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        })
        NSLog("linkedIn login success: %@", User.currentUser.allParams())
    }
    
    func logInGoogleSuccess(data: NSDictionary?) {
        
        guard let aData = data else {
            MSXLogInManager.endLogin(self.controller)
            return
        }
        User.currentUser.initFromGoogleData(aData, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
               MSXLogInManager.endLogin(this.controller)
            } else {
                MXSActivityIndicator.stopAnimating()
            }
        })
        NSLog("google login success: %@", User.currentUser.allParams())
    }
    
    static func endLogin(viewController: UIViewController) {
        
        MXSActivityIndicator.stopAnimating()
        viewController.navigationController?.viewDidLoad()
    }
}