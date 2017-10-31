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




/// A list of different kind of constants.
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
        static let kBackGroundColor    = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) // black
        static let kDefaultTextColor   = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) // black
        static let kSpecialColor       = UIColor(red: 146/255, green: 39/255, blue: 143/255, alpha: 1)
        static let kSpecialColorClear  = UIColor(red: 146/255, green: 39/255, blue: 143/255, alpha: 0.9)
        static let kTextFieldUnderLine = UIColor.white
    }
    
    /**
     *  A struct of constants about the Urls.
     */
    struct URLS {
        static let mapTemplate = "https://api.mapbox.com/styles/v1/mohamed31/ciyvv80dh00bv2sppa6ny6sqj/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoibW9oYW1lZDMxIiwiYSI6ImNpeXZ1MzE0aTAwNHkycW9lazU0YXhycGYifQ.2WLwZvBarfp1jAxjNt2miA"
    }
    
    /**
     *  A struct of constants about social media sharing.
     */
    struct Sharings {
        static let textToShare = "Pouvoir allier vie professionnelle et activité physique est une nécessité pour quiconque souhaite conserver un esprit sain dans un corps sain."
        
        static let websiteShare = URL(string: "http://meetxsweat.com")!
        static let imgShare     = UIImage(named: Ressources.Images.mxslogo)!
    }
    
    static let mToKm       = 1000.0
    
    /**
     *  A struct of constants about a text attributes.
     */
    static let placeHolderAttributes = [
        NSForegroundColorAttributeName: UIColor.white,
        //NSFontAttributeName : UIFont(name: "Roboto-Bold", size: 17)! // Note the !
    ]
    
    static let tabBarHeight: CGFloat = 50
}

