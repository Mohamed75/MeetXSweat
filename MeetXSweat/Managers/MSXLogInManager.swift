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
    
    var controller: UIViewController!
    
    
    func logIn(logInType: LogInType, viewController: UIViewController) {
        
        self.controller = viewController
        
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
    
    func logInFBSuccess(data: NSDictionary) {
        
        User.currentUser.initFromFBData(data, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this.controller)
            }
        })
        NSLog("facebook login success: %@", User.currentUser.allParams())
    }
    
    func logInTWSuccess(data: NSDictionary) {
        
        User.currentUser.initFromTWData(data, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this.controller)
            }
        })
        NSLog("twitter login success: %@", User.currentUser.allParams())
    }
    
    func logInLKSuccess(data: NSDictionary) {
        
        User.currentUser.initFromLKData(data, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
                MSXLogInManager.endLogin(this.controller)
            }
        })
        NSLog("linkedIn login success: %@", User.currentUser.allParams())
    }
    
    func logInGoogleSuccess(data: NSDictionary) {
        
        User.currentUser.initFromGoogleData(data, completion: { [weak self] (done) in
            
            guard let this = self else {
                return
            }
            if done {
               MSXLogInManager.endLogin(this.controller)
            }
        })
        NSLog("google login success: %@", User.currentUser.allParams())
    }
    
    static func endLogin(viewController: UIViewController) {
        viewController.navigationController?.viewDidLoad()
    }
}