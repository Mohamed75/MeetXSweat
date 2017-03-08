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
        return ["Trouvez un profil professionnel et \n rencontrez le pendant un \n entrainement",
                "Choisissez votre Sport et profitez en \n pour rencontrer des profils \n professionnels",
                "Choisissez vos dates \n pour networker et s'entrainer",
                "Trouvez les événements de sport et \n networking autour de vous!"]
    }
    
    
    class func uploadDomaines() {
        
        let domainesRef = FIRDatabase.database().reference().child("domaine-items")
        for domaine in self.getDomaines() {
            let ref = domainesRef.childByAutoId()
            ref.setValue(domaine)
        }
    }
    
    class func uploadProfessions() {
        
        let professionsRef = FIRDatabase.database().reference().child("profession-items")
        for profession in self.getProfessions() {
            let ref = professionsRef.childByAutoId()
            ref.setValue(profession)
        }
    }
}
