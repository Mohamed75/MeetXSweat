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
    
    class func getExperiences() -> [String] {
        return ["0-2", "2-5", "5-10", ">10"]
    }
    
    class func getSports()  -> [String] {
        return ["CrossFit", "Yoga", "Running", "Boxe", "Golf", "Foot", "Basket", "Velo", "Natation", "Pilates", "Gym-suedoise", "Trail"]
    }
}
