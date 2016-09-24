//
//  GoogleLogInHelper.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Google
import GoogleSignIn


private let getUserInfoUrlString = "https://www.googleapis.com/oauth2/v3/userinfo?access_token="


protocol LogInGoogleDelegate {
    func logInGoogleSuccess(data: NSDictionary)
}


class GoogleLogInHelper: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let sharedInstance = GoogleLogInHelper()
    
    var controllerDelegate: LogInGoogleDelegate!
    
    class func initConfig() {
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = GoogleLogInHelper.sharedInstance
        
        GIDSignIn.sharedInstance().uiDelegate = GoogleLogInHelper.sharedInstance
    }
    
    class func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    class func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    
    
    @objc func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let url = NSURL(string: getUserInfoUrlString+user.authentication.accessToken)
            let session = NSURLSession.sharedSession()
            
            unowned let weakSelf = self
            session.dataTaskWithURL(url!) {(data, response, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                do {
                    let userData = try NSJSONSerialization.JSONObjectWithData(data!, options:[])
                    
                    guard let JSONDictionary: NSDictionary = userData as? NSDictionary else {
                        return
                    }
                    
                    weakSelf.controllerDelegate.logInGoogleSuccess(JSONDictionary)
                    
                } catch {
                    NSLog("Google LogIn Account Information could not be loaded")
                }
                }.resume()
        }
        else {
            print("google logIn \(error.localizedDescription)")
        }
    }
    
    
    @objc func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
    }
    
    
    // Mark: UIDelegate
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        getVisibleViewController().presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        getVisibleViewController().dismissViewControllerAnimated(true, completion: nil)
    }
}
