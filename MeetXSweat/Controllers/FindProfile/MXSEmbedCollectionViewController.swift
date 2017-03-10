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
            titleLabel.text = Strings.LabelTitel.lesSports
            addBarButtonItem()
            return
        }
        
        switch MXSFindManager.sharedInstance.findBy {
            
        case FindBy.sport :
            if let eventsCollectionViewController = childViewControllers.first as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = MXSFindManager.filterEventsBySports()
                
                titleLabel.text = Strings.LabelTitel.sports
                for sport in MXSFindManager.sharedInstance.sports {
                    titleLabel.text = titleLabel.text! + " " + (sport as! String).uppercased()
                }
                
                if eventsCollectionViewController.fromProfileViewController {
                } else {
                    title = Strings.NavigationTitle.events
                }
            }
            break
          
        case FindBy.date :
            if let eventsCollectionViewController = childViewControllers.first as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = MXSFindManager.filterEventsByDates()
            }
            break
        
        case FindBy.profile :
            if let personsCollectionViewController = childViewControllers.first as? MXSPersonsCollectionViewController {
                
                if !MXSFindManager.sharedInstance.domaine.isEmpty {
                    titleLabel.text = MXSFindManager.sharedInstance.domaine
                }
                if !MXSFindManager.sharedInstance.profession.isEmpty {
                    titleLabel.text = MXSFindManager.sharedInstance.profession
                    
                }
                personsCollectionViewController.persons = MXSFindManager.filterBy(FireBaseDataManager.sharedInstance.persons)
                title = Strings.NavigationTitle.profiles
            }
            break
            
        default:
            break
        }
        
    }
    
    
}
