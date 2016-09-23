//
//  MXSFindProfileViewController2.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSEmbedCollectionViewController: MXSViewController {
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if MXSHomeViewController.sharedInstance.findBy == FindBy.Sport {
            let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController
            eventsCollectionViewController?.events = FindSportManager.filterEventsBySports(FindSportManager.sharedInstance.sports)
            
        }
        
        if MXSHomeViewController.sharedInstance.findBy == FindBy.Profile {
            let personsCollectionViewController = self.childViewControllers[0] as? MXSPersonsCollectionViewController
            personsCollectionViewController?.persons = FindProfileManager.filterBy(DummyData.getPerons(), filter: FindProfileManager.sharedInstance.profession)
        }
    }
}