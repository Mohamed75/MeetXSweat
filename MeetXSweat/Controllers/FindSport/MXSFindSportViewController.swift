//
//  MXSFindSportViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton



class MXSFindSportViewController: MXSViewController {
    
    
    @IBOutlet weak var validerButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MSXFindManager.sharedInstance.findBy = FindBy.Sport
        
        self.addBarButtonItem()
        self.addValiderButton()
        
        self.title = Ressources.NavigationTitle.sports
    }
    
    override func validatButtonClicked(sender: AnyObject) {
        validerButton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
        if let sportsCollectionViewController = self.childViewControllers[0] as? MXSSportsCollectionViewController {
            sportsCollectionViewController.validateSelections()
        }
    }
    
}
