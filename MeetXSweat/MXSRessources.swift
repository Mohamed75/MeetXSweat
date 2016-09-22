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
    }
    
    /**
     *  A struct of constants about the StoryBoards.
     */
    struct StoryBooards {
        
        static let main    = "Main"
        static let findProfile   = "MXSFindProfile"
        static let profile = "MXSProfile"
        static let event = "MXSEvent"
    }
    
    /**
     *  A struct of constants about the StoryBoard Identifiers.
     */
    struct StoryBooardsIdentifiers {
        
        // Main StoryBoard
        static let homeId       = "MXSHomeViewController"
        static let logInId      = "MXSAllLoginsViewController"
        
        // FindProfile StoryBoard
        static let findProfileId   = "MXSFindProfileViewController1"
        
        // Profile StoryBoard
        static let profileId = "MXSProfileViewController"
        
        // Events StoryBoard
        static let eventId = "MXSEventViewController"
    }
}