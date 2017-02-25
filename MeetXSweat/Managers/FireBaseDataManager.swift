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
    
    init() {
        
        FIRDatabase.database().reference().keepSynced(true)
        loadData()
    }
    
    
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
            _professions = newValue
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
            _domaines = newValue
        }
    }
    
    
    
    
    private func _eventBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) in
            
            guard let this = self else {
                return
            }
            let event = Event(snapshot: snapshot)
            this.events.append(event)
        }
    }
    
    private func _personBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            this.persons.append(Person(snapshot: snapshot))
        }
    }
    
    private func _sportBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let sport = snapshot.value!["name"] as? String {
                this._sports.append(sport)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.FBNotificationName.sports, object: nil)
            }
        }
    }
    
    private func _professionBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let profession = snapshot.value!["name"] as? String {
                this._professions.append(profession)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.FBNotificationName.professions, object: nil)
            }
        }
    }
    
    private func _domaineBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let domaine = snapshot.value!["name"] as? String {
                this._domaines.append(domaine)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.FBNotificationName.domaines, object: nil)
            }
        }
    }
    
    private var _eventRef    = FIRDatabaseReference()
    private var _personRef   = FIRDatabaseReference()
    private var _sportRef    = FIRDatabaseReference()
    private var _professionRef = FIRDatabaseReference()
    private var _domaineRef  = FIRDatabaseReference()
    
    func loadData() {
        
        events = []
        _eventRef.removeAllObservers()
        _eventRef = FIRDatabase.database().reference().child("event-items")
        _eventRef.observeEventType(.ChildAdded, withBlock: _eventBlock())
        
        
        persons = []
        _personRef.removeAllObservers()
        _personRef = FIRDatabase.database().reference().child("person-items")
        _personRef.observeEventType(.ChildAdded, withBlock: _personBlock())
        
        _sports = []
        _sportRef.removeAllObservers()
        _sportRef = FIRDatabase.database().reference().child("sport-items")
        _sportRef.observeEventType(.ChildAdded, withBlock: _sportBlock())
        
        _professions = []
        _professionRef.removeAllObservers()
        _professionRef = FIRDatabase.database().reference().child("profession-items")
        _professionRef.observeEventType(.ChildAdded, withBlock: _professionBlock())
        
        _domaines = []
        _domaineRef.removeAllObservers()
        _domaineRef = FIRDatabase.database().reference().child("domaine-items")
        _domaineRef.observeEventType(.ChildAdded, withBlock: _domaineBlock())
    }
    
    
    class func updateCurrentUserInPersons() {
        
        for person in FireBaseDataManager.sharedInstance.persons {
            if person.email == User.currentUser.email {
                User.currentUser.copyToPerson(person)
            }
        }
    }
    
}


