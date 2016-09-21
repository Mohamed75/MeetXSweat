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
    func logInLKSuccess(data: NSDictionary)
}


class UtilsLiknedInHelper {
    
    
    
    class func logIn(delegate: LogInLKDelegate) {
        
        let linkedIn = LinkedInHelper.sharedInstance()
        
        linkedIn.cancelButtonText = closeString
    
        let permissions = [Permissions.BasicProfile.rawValue, Permissions.EmailAddress.rawValue, Permissions.Share.rawValue, Permissions.CompanyAdmin.rawValue]
        
        linkedIn.showActivityIndicator = true
        linkedIn.requestMeWithSenderViewController(getVisibleViewController(), clientId: LINKEDIN_CLIENT_ID, clientSecret: LINKEDIN_CLIENT_SECRET, redirectUrl: REDIRECT_URL, permissions: permissions, state: DEFAULT_STATE, successUserInfo: { (userInfo) in
            
                delegate.logInLKSuccess(userInfo)
                linkedIn.showActivityIndicator = false
            
            }) { (error) in
                NSLog("linkedIn logIn error : %@", error.userInfo.description)
                linkedIn.showActivityIndicator = false
        }
    
    }
    
    
}