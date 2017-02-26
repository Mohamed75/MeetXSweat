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
        
        addBarButtonItem()
        addValiderButton()
        
        title = Strings.NavigationTitle.sports
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        MSXFindManager.sharedInstance.findBy = FindBy.sport
    }
    
    override func refreshView() {
        if let sportsCollectionViewController = childViewControllers.first as? MXSSportsCollectionViewController {
            sportsCollectionViewController.sports = FireBaseDataManager.sharedInstance.sports
            sportsCollectionViewController.collectionView?.reloadData()
        }
    }
    
    override func validatButtonClicked(_ sender: AnyObject) {
        validerButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func validerButtonClicked(_ sender: AnyObject) {
        
        if let sportsCollectionViewController = childViewControllers.first as? MXSSportsCollectionViewController {
            sportsCollectionViewController.validateSelections()
        }
    }
    
}
