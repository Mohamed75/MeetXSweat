//
//  Strings.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


/// A list of different kind of strings.
enum Strings {
    
    struct Calendar {
        static let titleText = "SELECTIONNER TES DISPONIBILITES"
    }
    
    struct Home {
        static let cell1Text = "Trouver un profil professionel"
        static let cell2Text = "Trouver un sport"
        static let cell3Text = "Trouver une date de disponnible"
        static let cell4Text = "Trouver ce qu'il y'as autour de moi"
        static let numberOfSections =  4
    }
    
    struct Alert {
        static let enterEmailMessage = "Veuillez saisir votre email"
        static let cancel   = "Cancel"
        static let ok       = "OK"
        static let fillAllFieldsMessage = "Veuillez remplir tous les champs!"
        static let wrongEmailMesssage   = "Votre email n'est pas valide!"
    }
    
    struct Account {
        static let email    = "E-mail"
        static let password = "Password"
        static let name     = "Nom"
        static let lastName = "Prénom"
    }
    
    struct LabelTitel {
        static let sports       = "TOUS LES PLANS"
        static let lesSports    = "Vos sweatworkings"
    }
    
    struct NavigationTitle {
        
        static let sports       = "SPORTS"
        static let map          = "MAP"
        static let rechercher   = "RECHERCHER"
        static let planning     = "PLANNING"
        static let wellComme    = "Bienvenue"
        static let tuttorial    = ""
        
        static let sportsParticipants = "PARTICIPANTS"
        static let profiles     = "PROFILES"
        static let events       = "VOS SPORTS"
        static let event        = "PRESENTATION DE L'EVENT"
        static let profile      = "PROFIL"
        
        static let conversations = "CONVERSATIONS"
        static let messages      = "MESSAGES"
        static let sweatWorking  = "SWEATWORKING"
    }
}

