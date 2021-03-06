//
//  GoogleLogInHelper.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import GoogleSignIn


private let kGetUserInfoUrlString = "https://www.googleapis.com/oauth2/v3/userinfo?access_token="

#if PROD
private let GOOGLE_CCLIENT_ID  = "696269792910-a8vvnf1a8tpvm99nontm9239agil6b12.apps.googleusercontent.com"
#else
private let GOOGLE_CCLIENT_ID  = "507333318603-1qfm75lhj9v05ledk92a6dtnnsdp8imc.apps.googleusercontent.com"
#endif
    

protocol LogInGoogleDelegate {
    func logInGoogleSuccess(_ data: NSDictionary?)
}


/**
 *  This class was designed and implemented to provide Google logIn helper.
 It help the user to connect trought Google and gather its data
 
 - classdesign  Helper.
 - classdesign  Singleton, Delegate.
 */

class GoogleLogInHelper: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let sharedInstance = GoogleLogInHelper()
    
    fileprivate var controllerDelegate: LogInGoogleDelegate!
    
    
    
    // MARK: - *** UIApplication ***
    
    class func application(_ application: UIApplication, openURL url: URL, options: [String: AnyObject]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication._rawValue as String] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation._rawValue as String])
    }
    
    class func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    // MARK: - *** Initialization ***
    
    fileprivate func initConfig() {
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID     = GOOGLE_CCLIENT_ID
        GIDSignIn.sharedInstance().delegate     = self
        GIDSignIn.sharedInstance().uiDelegate   = self
    }
    
    
    // MARK: - *** LogIn/LogOut ***
    
    func logIn(_ delegate: LogInGoogleDelegate) {
        
        initConfig()
        controllerDelegate = delegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    func logOut() {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    
    // MARK: - *** GIDSignIn Delegate ***
    
    @objc func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let url = URL(string: kGetUserInfoUrlString+user.authentication.accessToken)
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
    
    
    // MARK: - *** UIDelegate ***
    
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
