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
        //DummyData.uploadDomaines()
        //DummyData.uploadProfessions()
    }
    
    
    fileprivate var _sports: [String] = []
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
    
    fileprivate var _professions: [String] = []
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
    
    fileprivate var _domaines: [String] = []
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
    
    
    
    
    fileprivate func _eventBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) in
            
            guard let this = self else {
                return
            }
            let event = Event(snapshot: snapshot)
            this.events.append(event)
        }
    }
    
    fileprivate func _personBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            this.persons.append(Person(snapshot: snapshot))
        }
    }
    
    fileprivate func _sportBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let dict = snapshot.value as? NSDictionary, let sport = dict["name"] as? String {
                this._sports.append(sport)
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.FBNotificationName.sports), object: nil)
            }else {
            }
        }
    }
    
    fileprivate func _professionBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let dict = snapshot.value as? NSDictionary, let profession = dict["name"] as? String {
                this._professions.append(profession)
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.FBNotificationName.professions), object: nil)
            }
        }
    }
    
    fileprivate func _domaineBlock() -> (FIRDataSnapshot) -> Void {
        
        return { [weak self] (snapshot) -> Void in
            
            guard let this = self else {
                return
            }
            if let dict = snapshot.value as? NSDictionary, let domaine = dict["name"] as? String {
                this._domaines.append(domaine)
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.FBNotificationName.domaines), object: nil)
            }
        }
    }
    
    fileprivate var _eventRef    = FIRDatabaseReference()
    fileprivate var _personRef   = FIRDatabaseReference()
    fileprivate var _sportRef    = FIRDatabaseReference()
    fileprivate var _professionRef = FIRDatabaseReference()
    fileprivate var _domaineRef  = FIRDatabaseReference()
    
    func loadData() {
        
        events = []
        _eventRef.removeAllObservers()
        _eventRef = FIRDatabase.database().reference().child("event-items")
        _eventRef.observe(.childAdded, with: _eventBlock())
        
        
        persons = []
        _personRef.removeAllObservers()
        _personRef = FIRDatabase.database().reference().child("person-items")
        _personRef.observe(.childAdded, with: _personBlock())
        
        _sports = []
        _sportRef.removeAllObservers()
        _sportRef = FIRDatabase.database().reference().child("sport-items")
        _sportRef.observe(.childAdded, with: _sportBlock())
        
        _professions = []
        _professionRef.removeAllObservers()
        _professionRef = FIRDatabase.database().reference().child("profession-items")
        _professionRef.observe(.childAdded, with: _professionBlock())
        
        _domaines = []
        _domaineRef.removeAllObservers()
        _domaineRef = FIRDatabase.database().reference().child("domaine-items")
        _domaineRef.observe(.childAdded, with: _domaineBlock())
    }
    
    
    class func updateCurrentUserInPersons() {
        
        for person in FireBaseDataManager.sharedInstance.persons {
            if person.email == User.currentUser.email {
                User.currentUser.copyToPerson(person)
            }
        }
    }
    
}


