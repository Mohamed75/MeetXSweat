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
    func logInGoogleSuccess(_ data: NSDictionary?)
}


class GoogleLogInHelper: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let sharedInstance = GoogleLogInHelper()
    
    fileprivate var controllerDelegate: LogInGoogleDelegate!
    
    
    
    class func application(_ application: UIApplication, openURL url: URL, options: [String: AnyObject]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication._rawValue as String] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation._rawValue as String])
    }
    
    class func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    
    fileprivate func initConfig() {
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate     = self
        GIDSignIn.sharedInstance().uiDelegate   = self
    }
    
    
    func logIn(_ delegate: LogInGoogleDelegate) {
        
        initConfig()
        controllerDelegate = delegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    func logOut() {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    
    
    @objc func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let url = URL(string: getUserInfoUrlString+user.authentication.accessToken)
            let session = URLSession.shared
            
            let block: (Data?, URLResponse?, Error?) -> Void = { [weak self] (data, response, error) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                do {
                    let userData = try JSONSerialization.jsonObject(with: data!, options:[])
                    
                    guard let JSONDictionary: NSDictionary = userData as? NSDictionary else {
                        return
                    }
                    guard let this = self else {
                        return
                    }
                    this.controllerDelegate.logInGoogleSuccess(JSONDictionary)
                    
                } catch {
                    NSLog("Google LogIn Account Information could not be loaded")
                }
            }
            session.dataTask(with: url!, completionHandler: block).resume()
        }
        else {
            print("google logIn \(error.localizedDescription)")
            self.controllerDelegate.logInGoogleSuccess(nil)
        }
    }
    
    
    @objc internal func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
    }
    
    
    // Mark: UIDelegate
    
    internal func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    internal func sign(_ signIn: GIDSignIn!,
                present viewController: UIViewController!) {
        getVisibleViewController().present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    internal func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        getVisibleViewController().dismiss(animated: true, completion: nil)
    }
}
