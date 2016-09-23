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
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
        if let sportsCollectionViewController = self.childViewControllers[0] as? MXSSportsCollectionViewController {
            sportsCollectionViewController.validateSelections()
        }
        
    }
    
}
