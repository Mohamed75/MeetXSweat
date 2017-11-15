//
//  MXSFindCollectionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

/**
 *  This class was designed and implemented to provide a standar ViewController with only a title label and a ContainerView of a CollectionView to show the Events/Profiles finded.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MXSFindManager.
 */

class MXSFindCollectionViewController: MXSViewController {
    
    
    @IBOutlet weak var topView: MXSTopView!
    
    // A property to know that we need to cutomize litle bit the view
    var isSweatWorking = false
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.MainColor.kBackGroundColor
        self.topView.draw(self.topView.frame)
        
        if isSweatWorking {
            
            title = Strings.NavigationTitle.sweatWorking
            topView.topLabel.text = Strings.LabelTitel.lesSports
            addBarButtonItem()
            return
        }
        
        switch MXSFindManager.sharedInstance.findBy {
            
        case FindBy.sport :
            if let eventsCollectionViewController = childViewControllers.first as? MXSEventsCollectionViewController {
                
                eventsCollectionViewController.events = MXSFindManager.filterEventsBySports()
                
                topView.topLabel.text = Strings.LabelTitel.sports
                for sport in MXSFindManager.sharedInstance.sports {
                    topView.topLabel.text = topView.topLabel.text! + " " + (sport as! String).uppercased()
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
                    topView.topLabel.text = MXSFindManager.sharedInstance.domaine
                }
                if !MXSFindManager.sharedInstance.profession.isEmpty {
                    topView.topLabel.text = MXSFindManager.sharedInstance.profession
                    
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
