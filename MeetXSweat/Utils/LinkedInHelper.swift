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

private let kCloseString            = "Close"




protocol LogInLKDelegate {
    func logInLKSuccess(_ data: NSDictionary?)
}


/**
 *  This class was designed and implemented to provide LinkedIn logIn helper.
 It help the user to connect trought LinkedIn and gather its data
 
 - classdesign  Helper.
 */

class LiknedInHelper {
    
    // MARK: - *** LogIn/LogOut ***
    
    class func logIn(_ delegate: LogInLKDelegate) {
        
        let permissions = [Permissions.BasicProfile.rawValue, Permissions.EmailAddress.rawValue, Permissions.Share.rawValue, Permissions.CompanyAdmin.rawValue]
        
        if let linkedIn = LinkedInHelper.sharedInstance() {
        
            linkedIn.cancelButtonText = kCloseString
            linkedIn.showActivityIndicator = true
            
            
            let successBlock: ([AnyHashable: Any]?) -> Void = { (userInfo) in
                
                delegate.logInLKSuccess(userInfo as NSDictionary?)
                linkedIn.showActivityIndicator = false
            }
            
            let failerBlock: ((Error?) -> Void) = { (error) in
                if let aError = error {
                    NSLog("linkedIn logIn error : %@", aError._userInfo.debugDescription)
                }
                delegate.logInLKSuccess(nil)
                linkedIn.showActivityIndicator = false
            }
            
            linkedIn.requestMeWithSenderViewController(getVisibleViewController(), clientId: LINKEDIN_CLIENT_ID, clientSecret: LINKEDIN_CLIENT_SECRET, redirectUrl: REDIRECT_URL, permissions: permissions, state: DEFAULT_STATE, successUserInfo: successBlock, failUserInfoBlock: failerBlock)
        }
    }
    
    
    class func logOut() {
        
        LinkedInHelper.sharedInstance().logout()
    }
    
}
