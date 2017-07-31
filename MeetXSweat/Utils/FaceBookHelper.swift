//
//  FaceBookManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation

import Accounts
import FBSDKCoreKit
import FBSDKLoginKit
import Social

// userInfo request
private let kParametersField = "picture, email, first_name, last_name, gender, birthday, work"
private let kGetUserInfoUrl  = URL(string: "https://graph.facebook.com/me")

// initialisation
private let kPermessionArray = ["public_profile", "email", "user_friends", "user_about_me"]
private let kFBApiKey  = getValueFromInfoPlist("FacebookAppID") as! String
private let kFBOptions = [ACFacebookAppIdKey: kFBApiKey, ACFacebookPermissionsKey: kPermessionArray] as [AnyHashable : Any]


private let kFBAccountType = ACAccountStore().accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierFacebook)




private let kFBControllerClassName    = "FBSDKContainerViewController"


protocol LogInFBDelegate {
    func logInFBSuccess(_ data: NSDictionary?)
}



/**
 *  This class was designed and implemented to provide FaceBook logIn helper.
 It help the user to connect trought FaceBook and gather its data
 
 - classdesign  Helper.
 - classdesign  Singleton.
 */

class FaceBookHelper {
    
    static let sharedInstance = FaceBookHelper()
    
    
    
    // Mark: --- UIApplication ---
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    
    
    
    // Mark: ---  LogIn/LogOut ---
    
    
    // Avoid multiple click on the login button
    fileprivate var isLoginBlocked = false
    
    fileprivate func logInblock(_ delegate: LogInFBDelegate) -> ACAccountStoreRequestAccessCompletionHandler {
        
        return { [weak self] (granted, error) -> Void in
            
            guard let this = self else {
                return
            }
            
            if granted
            {
                let accounts = ACAccountStore().accounts(with: kFBAccountType)
                if let facebookAccount = accounts?.last as? ACAccount {
                    FaceBookHelper.getUserInfo(facebookAccount.credential.oauthToken!, delegate: delegate)
                }
            }
            else
            {
                if this.isLoginBlocked == false {
                    FaceBookHelper.faceBookWebLogin(delegate)
                    // For first launch sometimes the loginWebView dont pop up, so this code force the loginWebview
                    this.isLoginBlocked = true
                    Thread.sleep(forTimeInterval: 1.5)
                    if getVisibleViewController().classForCoder.description() != kFBControllerClassName {
                        FaceBookHelper.faceBookWebLogin(delegate)
                        NSLog("#faceBookWebLogin")
                    }
                    this.isLoginBlocked = false
                }
            }
        }
    }
    
    func logIn(_ delegate: LogInFBDelegate) {
        
        if isIOSVersionGReaterThan(version: 9.9) {
            ACAccountStore().requestAccessToAccounts(with: kFBAccountType, options: nil, completion: logInblock(delegate))
        } else {
            ACAccountStore().requestAccessToAccounts(with: kFBAccountType, options: kFBOptions, completion: logInblock(delegate))
        }
    }
    
    func logOut() {
        
        FBSDKLoginManager().logOut()
    }
    
    
    
    
    // MARK: --- webLogIn ---
    
    fileprivate class func faceBookWebLogin(_ delegate: LogInFBDelegate) {
        
        let webLogInBlock: FBSDKLoginManagerRequestTokenHandler = { (result, error) -> Void in
            
            if ((error) != nil) {
                NSLog("Facebook web signIn Process error")
                delegate.logInFBSuccess(nil)
            } else if (result?.isCancelled)! {
                NSLog("Facebook web signIn Cancelled")
                delegate.logInFBSuccess(nil)
            } else {
                NSLog("Facebook web signIn Logged in")
                
                if (FBSDKAccessToken.current() != nil) {
                    FaceBookHelper.getUserInfo(FBSDKAccessToken.current().tokenString, delegate: delegate)
                }
            }
        }
        
        dispatch_later(0.1) {
            FBSDKLoginManager().logIn(withReadPermissions: kPermessionArray, from: getVisibleViewController(), handler: webLogInBlock)
        }
    }
    
    
    // MARK: --- Get User Info ---
    
    fileprivate class func getUserInfo(_ token: String, delegate: LogInFBDelegate) {
        
        let getUserInfoParameters = ["fields" : kParametersField, "access_token" : token]
        let postRequest = SLRequest(forServiceType: SLServiceTypeFacebook,
                                    requestMethod: SLRequestMethod.GET,
                                    url: kGetUserInfoUrl,
                                    parameters: getUserInfoParameters)
        
        postRequest?.perform(handler:  { (responseData, urlResponse, error) in
            
            if (error == nil) {
                
                do {
                    let JSON = try JSONSerialization.jsonObject(with: responseData!, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        return
                    }
                    
                    delegate.logInFBSuccess(JSONDictionary)
                }
                catch let JSONError as NSError {
                    print("Facebook get userInfo \(JSONError)")
                }
            }
            
        })
    }
    
    
}
