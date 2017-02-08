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
        
        self.title = Ressources.NavigationTitle.sports
        
        let validatButton = UIButton(type: .Custom)
        validatButton.addTarget(self, action: #selector(validatButtonClicked), forControlEvents: .TouchUpInside)
        validatButton.setBackgroundImage(UIImage(named: Ressources.Images.valider), forState: .Normal)
        validatButton.frame = CGRectMake(0 ,0,30,30)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: validatButton)
    }
    
    @IBAction func validatButtonClicked(sender: AnyObject) {
        validerButton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
        if let sportsCollectionViewController = self.childViewControllers[0] as? MXSSportsCollectionViewController {
            sportsCollectionViewController.validateSelections()
        }
    }
    
}
