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
                
            } else if let personsCollectionViewController = childViewControllers.first as? MXSPersonsCollectionViewController {
                
                dispatch_later(0.1, closure: { [weak self] in
                    guard let this = self else {
                        return
                    }
                    this.customizeTopViewPersons(event: personsCollectionViewController.event!)
                })
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
    
    
    func customizeTopViewPersons(event: Event) {
        
        let sportName = event.sport
        self.topView.imageViewCenterConstraint.constant -= 60
        self.topView.imageView.image = UIImage(named: sportName.lowercased())
        self.topView.setNeedsLayout()
        
        let sportLabel = UILabel(frame: CGRect(x: self.topView.imageView.frame.origin.x-10, y: 13, width: self.topView.frame.size.width, height: 30))
        sportLabel.textColor = Constants.MainColor.kCustomBlueColor
        sportLabel.text = sportName
        sportLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.topView.addSubview(sportLabel)
        
        let adressLabel = UILabel(frame: CGRect(x: self.topView.imageView.frame.origin.x-10, y: 35, width: self.topView.frame.size.width, height: 30))
        adressLabel.textColor = UIColor.white
        adressLabel.text = event.adress
        adressLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.topView.addSubview(adressLabel)
    }
}
