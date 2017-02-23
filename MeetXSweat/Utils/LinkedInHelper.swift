//
//  LinkedInHelper.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/18/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import LinkedinIOSHelper


private let LINKEDIN_CLIENT_ID      = "77ecwwd6yxogn4"
private let LINKEDIN_CLIENT_SECRET  = "1zoGBnvBMm69ufL7"
private let REDIRECT_URL            = "https://www.meetxsweat.com/sample"
private let DEFAULT_STATE           = "DCEEFWF45453sdffef424"

private let closeString             = "Close"





protocol LogInLKDelegate {
    func logInLKSuccess(data: NSDictionary?)
}

//, failUserInfoBlock failure: ((NSError!) -> Void)!

class LiknedInHelper {
    
    
    
    class func logIn(delegate: LogInLKDelegate) {
        
        let permissions = [Permissions.BasicProfile.rawValue, Permissions.EmailAddress.rawValue, Permissions.Share.rawValue, Permissions.CompanyAdmin.rawValue]
        
        let linkedIn = LinkedInHelper.sharedInstance()
        linkedIn.cancelButtonText = closeString
        linkedIn.showActivityIndicator = true
        
        let successBlock: ([NSObject : AnyObject]!) -> Void = { (userInfo) in
            
            delegate.logInLKSuccess(userInfo)
            linkedIn.showActivityIndicator = false
            
        }
        
        let failerBlock: ((NSError!) -> Void) = { (error) in
            NSLog("linkedIn logIn error : %@", error.userInfo.description)
            delegate.logInLKSuccess(nil)
            linkedIn.showActivityIndicator = false
        }
        linkedIn.requestMeWithSenderViewController(getVisibleViewController(), clientId: LINKEDIN_CLIENT_ID, clientSecret: LINKEDIN_CLIENT_SECRET, redirectUrl: REDIRECT_URL, permissions: permissions, state: DEFAULT_STATE, successUserInfo: successBlock, failUserInfoBlock: failerBlock)
    
    }
    
    
}