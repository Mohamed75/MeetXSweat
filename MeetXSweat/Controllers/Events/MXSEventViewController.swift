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
        
        var text = ""
        if let dateArray = self.event.date?.componentsSeparatedByString(" - ") {
            text = dateArray[0]
            text = text + "       " + self.event.sport! + "\n"
            if dateArray.count > 1 {
                text = text + dateArray[1]
            }
        }
        midLabel.text = text
        if let persons = self.event.persons {
            participantsNumberLabel.text = String(persons.count) + " " + "participants"
        }
        
    }
    
    
    @IBAction func mapButtonClicked(sender: AnyObject) {
        
    }
    
    @IBAction func inscriptionButtonClicked(sender: AnyObject) {
    }
}
