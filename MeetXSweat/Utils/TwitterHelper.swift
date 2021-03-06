//
//  TwitterHelper.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit



private let kGetUserInfoUrlString    = "https://api.twitter.com/1.1/users/show.json"



protocol LogInTWDelegate {
    func logInTWSuccess(_ data: NSDictionary?)
}


/**
 *  This class was designed and implemented to provide Twitter logIn helper.
 It help the user to connect trought Twitter and gather its data
 
 - classdesign  Helper.
 */

class TwitterHelper {
    
    // MARK: - *** UIApplication ***
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) {
        
        if !Utils.isUnitTesting() {
            Fabric.with([Crashlytics.self, Twitter.self])
        }
    }
    
    // MARK: - *** LogIn/LogOut ***
    
    class func logIn(_ delegate: LogInTWDelegate) {
        
        let block: TWTRLogInCompletion = { session, error in
            if (session != nil) {
                print("Twitter signed in as \(session!.userName)")
                getUserInfo(delegate)
            } else {
                print("Twitter signIn error: \(error!.localizedDescription)")
                delegate.logInTWSuccess(nil)
            }
        }
        Twitter.sharedInstance().logIn(completion: block)
    }
    
    
    class func logOut() {
        
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        
        if let userId = TWTRAPIClient.withCurrentUser().userID {
            store.logOutUserID(userId)
        }
    }
    
    // MARK: - *** Get User Info ***
    
    fileprivate class func getUserInfo(_ delegate: LogInTWDelegate) {
        
        let client  = TWTRAPIClient.withCurrentUser()
        let request = client.urlRequest(withMethod: "GET",
                                                  url: kGetUserInfoUrlString,
                                                  parameters: ["user_id": client.userID!],
                                                  error: nil)
        
        let block: TWTRNetworkCompletion = { response, data, connectionError in
            
            if (connectionError == nil) {
                
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        return
                    }
                    
                    delegate.logInTWSuccess(JSONDictionary)
                }
                catch let JSONError as NSError {
                    print("Twitter get userInfo \(JSONError)")
                }
            }
        }
        client.sendTwitterRequest(request, completion: block)
        
        /* needs Twitter permission
        client.requestEmailForCurrentUser { (result, error) in
            let i = 0
        }*/
    }
    
    
}
