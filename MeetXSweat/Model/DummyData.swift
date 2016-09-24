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


// Dummy Data
private let personNames = ["Tony", "Alex", "Sedik", "John", "Alcapon"]
private let personlastNames = ["Montana", "LeCon", "Bendi", "Halliday", "Themaster"]
private let personProfessions = ["Developer", "Project Manager", "Medecin", "Professeur", "Developer"]
private let personSports = ["foot \ntennis", "foot \nbasket", "", "volley", "hand \nbasket"]


// Dummy Data
private let eventNames = ["MEET X SWEAT #RAFTING", "MEET X SWEAT #FOOT", "MEET X SWEAT #BOOTCAMP", "MEET X SWEAT #BASKET"]
private let eventDates = ["09 10 2016 - 14h00", "04 10 2016 - 15h00", "14 10 2016 - 15h00", "24 10 2016 - 15h00"]
private let eventAdresses = ["Base de loisir Cergy Rue des Étangs 95000 Cergy-Pontoise", "Bois de boulogne 75016 Paris", "Bois Colombes 92270", "Base de loisir Cergy Rue des Étangs 95000 Cergy-Pontoise"]
private let eventSports = ["RAFTING", "BOOTCAMP", "FOOT", "BASKET"]

class DummyData {
    
    // Dummy Data
    class func getPerons() -> [Person] {
        
        var returnArray: [Person] = []
        
        for i in 0...4 {
            
            let person = Person()
            person.name = personNames[i]
            person.lastName = personlastNames[i]
            person.profession = personProfessions[i]
            person.sport = personSports[i]
            returnArray.append(person)
        }
        return returnArray
    }
    
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
    
    
    class func getEvents() -> [Event] {
    
        let persons = getPerons()
        
        var returnArray: [Event] = []
        
        for i in 0...3 {
            
            let event = Event()
            event.name = eventNames[i]
            event.date = eventDates[i]
            event.adress = eventAdresses[i]
            event.sport = eventSports[i]
            let number1 = Int(arc4random_uniform(4))
            let number2 = Int(arc4random_uniform(4))
            event.persons = [persons[number1], persons[number2]]
            returnArray.append(event)
        }
        return returnArray
    }
}
