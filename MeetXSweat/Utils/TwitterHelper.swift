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
import Twitter


private let getUserInfoUrlString    = "https://api.twitter.com/1.1/users/show.json"



protocol LogInTWDelegate {
    func logInTWSuccess(data: NSDictionary)
}


class TwitterHelper {
    
    class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        Fabric.with([Crashlytics.self, Twitter.self])
    }
    
    
    class func logIn(delegate: LogInTWDelegate) {
        
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("Twitter signed in as \(session!.userName)");
                getUserInfo(delegate)
            } else {
                print("Twitter signIn error: \(error!.localizedDescription)");
            }
        }
    }
    
    
    class func getUserInfo(delegate: LogInTWDelegate) {
        
        let client = TWTRAPIClient.clientWithCurrentUser()
        let request = client.URLRequestWithMethod("GET",
                                                  URL: getUserInfoUrlString,
                                                  parameters: ["user_id": client.userID!],
                                                  error: nil)
        
        client.sendTwitterRequest(request) { response, data, connectionError in
        
            if (connectionError == nil) {
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
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
        
        /* needs Twitter permission
        client.requestEmailForCurrentUser { (result, error) in
            let i = 0
        }*/
    }
    
    
}
