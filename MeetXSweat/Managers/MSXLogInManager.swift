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
            UtilsLiknedInHelper.logIn(self)
        case .logInTypeGL:
            GoogleLogInHelper.sharedInstance.logIn(self)
        }
    }
    
    // MARK: --- LogIn Helpers callBacks ---
    
    func logInFBSuccess(data: NSDictionary) {
        
        NSLog("facebook login success: %@", User.currentUser.allParams())
        User.currentUser.initFromFBData(data, completion: { (done) in
            if done {
                self.controller.navigationController?.viewDidLoad()
            }
        })
    }
    
    func logInTWSuccess(data: NSDictionary) {
        
        NSLog("twitter login success: %@", User.currentUser.allParams())
        User.currentUser.initFromTWData(data, completion: { (done) in
            if done {
                self.controller.navigationController?.viewDidLoad()
            }
        })
    }
    
    func logInLKSuccess(data: NSDictionary) {
        
        NSLog("linkedIn login success: %@", User.currentUser.allParams())
        User.currentUser.initFromLKData(data, completion: { (done) in
            if done {
                self.controller.navigationController?.viewDidLoad()
            }
        })
    }
    
    func logInGoogleSuccess(data: NSDictionary) {
        
        NSLog("google login success: %@", User.currentUser.allParams())
        User.currentUser.initFromGoogleData(data, completion: { (done) in
            if done {
                self.controller.navigationController?.viewDidLoad()
            }
        })
    }
}