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
        
        switch MSXFindManager.sharedInstance.findBy {
            
        case FindBy.Sport :
            if let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = FindSportManager.filterEventsBySports(FindSportManager.sharedInstance.sports)
                
                self.titleLabel.text = Strings.LabelTitel.sports
                for sport in FindSportManager.sharedInstance.sports {
                    self.titleLabel.text = self.titleLabel.text! + " " + (sport as! String).uppercaseString
                }
                
                if eventsCollectionViewController.fromProfileViewController {
                } else {
                    self.title = Strings.NavigationTitle.events
                }
            }
            break
          
        case FindBy.Date :
            if let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = FindDateManager.filterEventsByDates(FindDateManager.sharedInstance.dates)
            }
            break
        
        case FindBy.Profile :
            if let personsCollectionViewController = self.childViewControllers[0] as? MXSPersonsCollectionViewController {
                
                personsCollectionViewController.persons = FindProfileManager.filterBy(FireBaseDataManager.sharedInstance.persons, filter: FindProfileManager.sharedInstance.profession)
                
                if !FindProfileManager.sharedInstance.domaine.isEmpty {
                    self.titleLabel.text = FindProfileManager.sharedInstance.domaine
                }
                if !FindProfileManager.sharedInstance.profession.isEmpty {
                    self.titleLabel.text = FindProfileManager.sharedInstance.profession
                }
                self.title = Strings.NavigationTitle.profiles
            }
            break
            
        default:
            break
        }
        
    }
    
    
}