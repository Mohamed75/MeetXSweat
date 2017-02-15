//
//  Ressources.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


/// A list of different kind of ressources.
enum Ressources {
    
    /**
     *  A struct of constants about the images.
     */
    struct Images {
        
        static let profilePlaceHolder    = "Profile_placeholder"
        static let ProfessionalProfile   = "ProfessionalProfile"
        static let event    = "Event"
        static let mxslogo  = "Logo"
        static let valider  = "Validation"
        static let back     = "Back"
        static let glBtn    = "GLButton"
        static let userSansPhoto    = "UserSansPhoto"
    }
    
    struct SportsImages {
        
        static let starSelected     = "star"
        static let starUnSelected   = "starClear"
    }
    
    /**
     *  A struct of constants about the StoryBoards.
     */
    struct StoryBooards {
        
        static let main             = "Main"
        static let findProfile      = "MXSFindProfile"
        static let profile          = "MXSProfile"
        static let wellCome         = "MXSWellCome"
        static let event            = "MXSEvent"
        static let findSport        = "MXSFindSport"
        static let findDate         = "MXSFindDate"
        static let findArroundMe    = "MXSFindArroundMe"
        static let conversation     = "MXSConversation"
    }
    
    /**
     *  A struct of constants about the StoryBoard Identifiers.
     */
    struct StoryBooardsIdentifiers {
        
        // Main StoryBoard
        static let logInId          = "MXSAllLoginsViewController"
        static let createAccountId  = "MXSCreateAccountViewController"
        static let addEvent         = "MXSAddEventViewController"
        
        // FindProfile StoryBoard
        static let findProfileId    = "MXSFindProfileViewController"
        
        // Profile StoryBoard
        static let profileId        = "MXSProfileViewController"
        
        // WellCome StoryBoard
        static let wellComeId       = "MXSWellComeViewController"
        static let tuttorialId      = "MXSTuttorialViewController"
        
        // Events StoryBoard
        static let eventId          = "MXSEventViewController"
        
        // FindSport StoryBoard
        static let findSportId      = "MXSFindSportViewController"
        
        // FindDate StoryBoard
        static let findDateId       = "MXSFindDateViewController"
        
        // FindArroudMe StoryBoard
        static let findArroundMeId  = "MXSFindArroundMeViewController"
        
        // Conversation StoryBoard
        static let conversationId   = "MXSConversationsViewController"
    }
    
    
    struct Xibs {
        
        static let calendarCellView = "MXSCalendarCellView"
    }
    
    
    struct CellReuseIdentifier {
        
        static let event        = "MXSEventsCollectionCell"
        static let person       = "MXSPersonCollectionCell"
        static let sport        = "MXSSportCollectionCell"
        static let conversation = "MXSConversationCollectionCell"
        static let tuttorial    = "MXSTuttorialCollectionCell"
        
        static let menu         = "MXSMenuTableViewCell"
    }
    
    struct MapPinIdentifier {
        static let eventsId     = "MXSPlaceMarkEvents"
        static let eventId      = "MXSPlaceMarkEvent"
    }
    
    struct NavigationTitle {
        
        static let sports       = "SPORTS"
        static let map          = "MAP"
        static let rechercher   = "RECHERCHER"
        static let wellCome     = "BIENVENUE"
        static let tuttorial    = "TUTTORIAL"
        
        static let sportsParticipants       = "PARTICIPANTS"
        static let profiles     = "PROFILES"
        static let events       = "VOS SPORTS"
        static let event        = "PRESENTATION DE L'EVENT"
    }
}