//
//  ViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import AlamofireImage


class MXSAllLoginsViewController: MXSViewController {

    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.evo_drawerController!.openDrawerGestureModeMask = []
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: --- LogIn Buttons Clicked ---
    
    @IBAction func faceBookLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeFB, viewController: self)
    }
    
    @IBAction func twitterLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeTW, viewController: self)
    }
    
    @IBAction func linkedInLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeLK, viewController: self)
    }
    
    @IBAction func googleLoginButtonClicked() {
        
        MSXLogInManager.sharedInstance.logIn(.logInTypeGL, viewController: self)
    }
}

