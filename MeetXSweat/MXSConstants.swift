//
//  MXSConstants.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

let kEndEditingSelectorString = "endEditing"

let kDateFormat             = "dd MM yyyy - HH:mm"
let kCalendarCellDateFormat = "yyyy-MM-dd"





enum Constants {
    
    /**
     *  A struct of constants about firebase Notification.
     */
    struct FBNotificationName {
        static let sports       = "sportNotification"
        static let domaines     = "domaineNotification"
        static let professions  = "professionNotification"
    }
    
    /**
     *  A struct of constants about firebase Notification.
     */
    struct FBNotificationSelector {
        static let sports       = NSSelectorFromString("selectorSportUpdated")
        static let domaines     = NSSelectorFromString("selectorDomaineUpdated")
        static let professions  = NSSelectorFromString("selectorProfessionUpdated")
    }
    
    struct SelectorsString {
        static let valider      = "validatButtonClicked:"
    }

    /**
     *  A struct of constants about the main colors.
     */
    struct MainColor {
        static let kNavigationBarColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) // black
        static let kBackGroundColor    = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) //white
        static let kDefaultTextColor   = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) // black
        static let kSpecialColor       = UIColor(red: 146/255, green: 39/255, blue: 143/255, alpha: 1)
        static let kSpecialColorClear  = UIColor(red: 146/255, green: 39/255, blue: 143/255, alpha: 0.9)
    }
    
    /**
     *  A struct of constants about the Urls.
     */
    struct URL {
        static let mapTemplate = "https://api.mapbox.com/styles/v1/mohamed31/ciyvv80dh00bv2sppa6ny6sqj/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoibW9oYW1lZDMxIiwiYSI6ImNpeXZ1MzE0aTAwNHkycW9lazU0YXhycGYifQ.2WLwZvBarfp1jAxjNt2miA"
    }
    
    static let mToKm       = 1000.0
}

