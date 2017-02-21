//
//  FireBaseDataManager.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import Foundation
import Firebase


class FireBaseDataManager {
    
    
    static let sharedInstance = FireBaseDataManager()
    
    var events: [Event]     = []
    var persons: [Person]   = []
    
    private var _sports: [String] = []
    var sports: [String] {
        get {
            if _sports.isEmpty {
                return DummyData.getSports()
            } else {
                return _sports
            }
        }
        set {
            self._sports = newValue
        }
    }
    
    private var _professions: [String] = []
    var professions: [String] {
        get {
            if _professions.isEmpty {
                return DummyData.getProfessions()
            } else {
                return _professions
            }
        }
        set {
            self._professions = newValue
        }
    }
    
    private var _domaines: [String] = []
    var domaines: [String] {
        get {
            if _domaines.isEmpty {
                return DummyData.getDomaines()
            } else {
                return _domaines
            }
        }
        set {
            self._domaines = newValue
        }
    }
    
    
    init() {
        
        loadData()
    }
    
    func loadData() {
        
        events = []
        let eventRef = FIRDatabase.database().reference().child("event-items")
        eventRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            let event = Event(snapshot: snapshot)
            this.events.append(event)
        })
        
        
        persons = []
        let personRef = FIRDatabase.database().reference().child("person-items")
        personRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            this.persons.append(Person(snapshot: snapshot))
        })
        
        _sports = []
        let sportRef = FIRDatabase.database().reference().child("sport-items")
        sportRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let sport = snapshot.value!["name"] as? String {
                this._sports.append(sport)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.FBNotificationName.sports, object: nil)
            }
        })
        
        _professions = []
        let professionRef = FIRDatabase.database().reference().child("profession-items")
        professionRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let profession = snapshot.value!["name"] as? String {
                this._professions.append(profession)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.FBNotificationName.professions, object: nil)
            }
        })
        
        _domaines = []
        let domaineRef = FIRDatabase.database().reference().child("domaine-items")
        domaineRef.observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let domaine = snapshot.value!["name"] as? String {
                this._domaines.append(domaine)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.FBNotificationName.domaines, object: nil)
            }
        })
    }
    
    
}


