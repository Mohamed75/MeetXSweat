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
        return ["CrossFit\n dsfqsdfqsdf sdfqsdf sqdgqgqf \n ergzertzert", "Yoga zzzzzzzzzzzze \n ergzeeeeeeeeeeeeeeeertzert", "Running zzzzzzzzzzzze", "Boxe zzzzzzzzzzzze", "Golf qdsfqsdfdfqsdf", "Foot  qdsfdsqfsdq", "Basket \n qsdfqdsfds\n aeartsgqsdgq", "Velo \nqart", "Natation \n aezfazefaze", "Pilates \nvsdsdfqsdf", "Gym-suedoise", "Trail"]
    }
}
