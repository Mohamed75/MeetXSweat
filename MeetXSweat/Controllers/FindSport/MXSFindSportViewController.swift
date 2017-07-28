//
//  MXSFindSportViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DLRadioButton


/**
 *  This class was designed and implemented to provide a ViewController to find Sports/Events.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MXSFindManager.
 */

class MXSFindSportViewController: MXSViewController {
    
    
    @IBOutlet weak var validerButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBarButtonItem()
        addValiderButton()
        
        title = Strings.NavigationTitle.sports
        
        FireBaseDataManager.sharedInstance.loadData()
        ConversationsDataManager.sharedInstance.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        MXSFindManager.sharedInstance.findBy = FindBy.sport
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
