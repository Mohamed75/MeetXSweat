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
        return ["Informatique", "Medical", "Social", "bancaire"]
    }
    
    class func getProfessions() -> [String] {
        return ["Developer", "Project Manager", "Medecin", "Professeur"]
    }
    
    class func getExperiences() -> [String] {
        return ["0-2", "2-5", "5-10", ">10"]
    }
    
    class func getSports()  -> [String] {
        return ["RAFTING", "BOOTCAMP", "FOOT", "BASKET", "VELO", "BOX", "NATATION", "MUSCULATION", "GOLF"]
    }
    
}
