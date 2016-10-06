//
//  MXSEventsViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSEventViewController: MXSViewController {
    
    var event: Event!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    
    @IBOutlet weak var participantsNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.image = UIImage(named: Ressources.Images.event)
        topLabel.text = self.event.adress
        
        let dateArray = self.event.date.componentsSeparatedByString(" - ")
        var text = dateArray[0]
        text = text + "       " + self.event.sport + "\n"
        if dateArray.count > 1 {
            text = text + dateArray[1]
        }
        midLabel.text = text
        participantsNumberLabel.text = String(self.event.persons.count) + " " + "participants"
        
        
        let personsCollectionViewController = self.childViewControllers[0] as? MXSPersonsCollectionViewController
        personsCollectionViewController?.persons = event.persons
    }
    
    
    @IBAction func mapButtonClicked(sender: AnyObject) {
       
        if self.event.placeMark != nil {
            
            let findArroundMeViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findArroundMe, viewControllerId: Ressources.StoryBooardsIdentifiers.findArroundMeId) as! MXSFindArroundMeViewController
            findArroundMeViewController.events = [self.event]
            self.navigationController?.pushViewController(findArroundMeViewController, animated: true)
            
        } else {
            // to force reload of geoloc adress
            self.event.adress = self.event.adress
        }
    }
    
    @IBAction func inscriptionButtonClicked(sender: AnyObject) {
    }
}
