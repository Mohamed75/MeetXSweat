//
//  MXSProfileDescriptionViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/24/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSProfileDescriptionViewController: MXSViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var person: Person!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addValiderButton()
        
        textView.text = person.personDescription
    }
    
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        person.personDescription = textView.text
        person.updatePersonOnDataBase(nil)
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
