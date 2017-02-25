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
    
    var isSweatWorking = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.backgroundColor = Constants.MainColor.kSpecialColor
        
        if isSweatWorking {
            
            title = Strings.NavigationTitle.sweatWorking
            titleLabel.text = "Vos sweatworkings"
            addBarButtonItem()
            return
        }
        
        switch MSXFindManager.sharedInstance.findBy {
            
        case FindBy.Sport :
            if let eventsCollectionViewController = childViewControllers.first as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = FindSportManager.filterEventsBySports(FindSportManager.sharedInstance.sports)
                
                titleLabel.text = Strings.LabelTitel.sports
                for sport in FindSportManager.sharedInstance.sports {
                    titleLabel.text = titleLabel.text! + " " + (sport as! String).uppercaseString
                }
                
                if eventsCollectionViewController.fromProfileViewController {
                } else {
                    title = Strings.NavigationTitle.events
                }
            }
            break
          
        case FindBy.Date :
            if let eventsCollectionViewController = childViewControllers.first as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = FindDateManager.filterEventsByDates(FindDateManager.sharedInstance.dates)
            }
            break
        
        case FindBy.Profile :
            if let personsCollectionViewController = childViewControllers.first as? MXSPersonsCollectionViewController {
                
                if !FindProfileManager.sharedInstance.domaine.isEmpty {
                    titleLabel.text = FindProfileManager.sharedInstance.domaine
                    personsCollectionViewController.persons = FindProfileManager.filterBy(FireBaseDataManager.sharedInstance.persons, filter: FindProfileManager.sharedInstance.domaine)
                }
                if !FindProfileManager.sharedInstance.profession.isEmpty {
                    titleLabel.text = FindProfileManager.sharedInstance.profession
                    personsCollectionViewController.persons = FindProfileManager.filterBy(FireBaseDataManager.sharedInstance.persons, filter: FindProfileManager.sharedInstance.profession)
                }
                title = Strings.NavigationTitle.profiles
            }
            break
            
        default:
            break
        }
        
    }
    
    
}