//
//  DummyData.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase



class DummyData {
    
    
    class func getDomaines() -> [String] {
        return ["Architecture", "Agroalimentaire", "Automobile / Aéronotique", "BTP", "Commercial / Vente", "Communication", "Comptabilité & finance", "Conseil", "Création & spectacle", "Digital", "Evénementiel", "Immobilier", "Informatique", "Ingénieurie", "Juridique", "Marketing", "Qualité", "Recherche", "Ressources Humaines", "Restauration & hotellerie", "Santé", "Service clientèle", "Services administratifs", "Sport", "Stratégie & Management", "Télécom"]
    }
    
    class func getProfessions() -> [String] {
        return ["Artisan", "Avocat", "Business manager", "Chef de projet", "Comédien", "Commercial", "Comptable", "Consultant", "Développeur", "Direction", "Entrepreneur", "Graphiste", "Ingénieur", "Journaliste", "Juriste", "Maitrise d'œuvre", "Maitrise d'ouvrage", "Photographe", "Réalisateur"]
    }
    
    class func getSports()  -> [String] {
        return ["CrossFit", "Yoga", "Running", "Boxe", "Golf", "Foot", "Basket", "Velo", "Natation", "Pilates", "Gym-suedoise", "Trail"]
    }
    
    class func getTuttorials()  -> [String] {
        return ["Rencontrer et échanger avec les profils \n professionnels qui vous intéressent \n lors de vos entrainements sportifs", "Découvrez les profils professionnels \n qui vous entourent lors de vos \n entrainements sportifs",
                "Choisissez vos sport et découvrez \n la sélection d’entrainement \n proposé pour y rencontrer \n des profils professionnels",
                "Indiquez vos dates de disponibilités \n et choisissez vos activités \n pour s’entrainer et networker"]
    }
    
    
    class func uploadDomaines() {
        
        let domainesRef = Database.database().reference().child("domaine-items")
        for domaine in DummyData.getDomaines() {
            let ref = domainesRef.childByAutoId()
            ref.setValue(domaine)
        }
    }
    
    class func uploadProfessions() {
        
        let professionsRef = Database.database().reference().child("profession-items")
        for profession in DummyData.getProfessions() {
            let ref = professionsRef.childByAutoId()
            ref.setValue(profession)
        }
    }
}
