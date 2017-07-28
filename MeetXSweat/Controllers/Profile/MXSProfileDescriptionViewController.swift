//
//  MXSProfileDescriptionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/24/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

/**
 *  This class was designed and implemented to provide a Profile Description ViewController.
 
 - superClass:  MXSViewController.
 */

class MXSProfileDescriptionViewController: MXSViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    internal var person: Person!
    
    
    // Mark: ---  View lifecycle ---
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addValiderButton()
        
        textView.text = person.personDescription
    }
    
    
    // Mark: --- NavigationBar Button Actions ---
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        person.personDescription = textView.text
        person.updatePersonOnDataBase(nil)
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
