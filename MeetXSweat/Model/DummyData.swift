//
//  DummyData.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation


// Dummy Data
private let domaines = ["Informatique", "Medical", "Social", "bancaire"]
private let professions = ["Developer", "Project Manager", "Medecin", "Professeur"]
private let experiences = ["0-2", "2-5", "5-10", ">10"]






class DummyData {
    
    
    class func getDomaines() -> [String] {
        return domaines
    }
    
    class func getProfessions() -> [String] {
        return professions
    }
    
    class func getExperiences() -> [String] {
        return experiences
    }
    
    class func getSports()  -> [String] {
        return ["RAFTING", "BOOTCAMP", "FOOT", "BASKET", "VELO", "BOX", "NATATION", "MUSCULATION", "GOLF"]
    }
    
}
