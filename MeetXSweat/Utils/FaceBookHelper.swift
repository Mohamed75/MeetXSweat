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


private let parametersField = "picture, email, first_name, last_name, gender, birthday, work"
private let getUserInfoUrl  = NSURL(string: "https://graph.facebook.com/me")
private let permessionArray = ["public_profile", "email", "user_friends", "user_about_me"]
private let faceBookApiKey  = getValueFromInfoPlist("FacebookAppID") as! String

private let fbController    = "FBSDKContainerViewController"



protocol LogInFBDelegate {
    func logInFBSuccess(data: NSDictionary?)
}


class FaceBookHelper {
    
    static let sharedInstance = FaceBookHelper()
    
    
    class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    // avoid multiple click on the login button
    private var isLoginBlock = false
    
    func logIn(delegate: LogInFBDelegate) {
        
        let options: [NSObject : AnyObject] = [ACFacebookAppIdKey: faceBookApiKey, ACFacebookPermissionsKey: permessionArray, ACFacebookAudienceKey:ACFacebookAudienceFriends]
        
        let accountStore = ACAccountStore()
        let facebookAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        
        
        accountStore.requestAccessToAccountsWithType(facebookAccountType, options: options) { [weak self] (granted, error) -> Void in
            
            guard let this = self else {
                return
            }
            
            if granted
            {
                let accounts = accountStore.accountsWithAccountType(facebookAccountType)
                if let facebookAccount = accounts.last as? ACAccount {
                    this.getUserInfo(facebookAccount.credential.oauthToken!, delegate: delegate)
                }
            }
            else
            {
                if this.isLoginBlock == false {
                    this.faceBookWebLogin(delegate)
                    // For first launch sometimes the loginWebView dont pop up, so this code force the loginWebview
                    this.isLoginBlock = true
                    NSThread.sleepForTimeInterval(1)
                    if getVisibleViewController().classForCoder.description() != fbController {
                        this.faceBookWebLogin(delegate)
                    }
                    this.isLoginBlock = false
                }
            }
        }
    }
    
    func faceBookWebLogin(delegate: LogInFBDelegate) {
        
        dispatch_later(0.0) {
            
            FBSDKLoginManager().logInWithReadPermissions(permessionArray, fromViewController: getVisibleViewController()) { [weak self] (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
                
                if ((error) != nil) {
                    NSLog("Facebook web signIn Process error")
                    delegate.logInFBSuccess(nil)
                } else if (result.isCancelled) {
                    NSLog("Facebook web signIn Cancelled")
                    delegate.logInFBSuccess(nil)
                } else {
                    NSLog("Facebook web signIn Logged in")
                    
                    if (FBSDKAccessToken.currentAccessToken() != nil) {
                        guard let this = self else {
                            return
                        }
                        this.getUserInfo(FBSDKAccessToken.currentAccessToken().tokenString, delegate: delegate)
                    }
                    
                }
            }
        }
    }
    
    
    
    func getUserInfo(token: String, delegate: LogInFBDelegate) {
        
        let getUserInfoParameters = ["fields" : parametersField, "access_token" : token]
        let postRequest = SLRequest(forServiceType: SLServiceTypeFacebook,
                                    requestMethod: SLRequestMethod.GET,
                                    URL: getUserInfoUrl,
                                    parameters: getUserInfoParameters)
        
        postRequest.performRequestWithHandler( { (responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
             
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(responseData, options:NSJSONReadingOptions(rawValue: 0))
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
