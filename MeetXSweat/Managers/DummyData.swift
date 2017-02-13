//
//  DummyData.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation




class DummyData {
    
    
    class func getDomaines() -> [String] {
        return ["Informatique", "Medical", "Social", "bancaire", "Autre", "Autre2", "Autre3", "Autre4", "Autre5"]
    }
    
    class func getProfessions() -> [String] {
        return ["Developer", "Project Manager", "Medecin", "Professeur"]
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
}
