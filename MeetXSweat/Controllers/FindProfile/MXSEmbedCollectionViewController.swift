//
//  MXSEmbedCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSEmbedCollectionViewController: MXSViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel.backgroundColor = Constants.MainColor.kSpecialColor
        
        if MSXFindManager.sharedInstance.findBy == FindBy.Sport {
            let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController
            eventsCollectionViewController?.events = FindSportManager.filterEventsBySports(FindSportManager.sharedInstance.sports)
        }
        
        if MSXFindManager.sharedInstance.findBy == FindBy.Date {
            let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController
            eventsCollectionViewController?.events = FindDateManager.filterEventsByDates(FindDateManager.sharedInstance.dates)
        }
        
        if MSXFindManager.sharedInstance.findBy == FindBy.Profile {
            let personsCollectionViewController = self.childViewControllers[0] as? MXSPersonsCollectionViewController
            personsCollectionViewController?.persons = FindProfileManager.filterBy(FireBaseDataManager.sharedInstance.persons, filter: FindProfileManager.sharedInstance.profession)
            
            if !FindProfileManager.sharedInstance.domaine.isEmpty {
                self.titleLabel.text = FindProfileManager.sharedInstance.domaine
            }
            if !FindProfileManager.sharedInstance.profession.isEmpty {
                self.titleLabel.text = FindProfileManager.sharedInstance.profession
            }
        }
    }
    
    
}