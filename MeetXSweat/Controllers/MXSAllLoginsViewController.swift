//
//  ViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/17/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import AlamofireImage


class MXSAllLoginsViewController: MXSViewController, LogInFBDelegate, LogInTWDelegate, LogInLKDelegate, LogInGoogleDelegate {

    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GoogleLogInHelper.sharedInstance.controllerDelegate = self
        
        self.evo_drawerController!.openDrawerGestureModeMask = []
    }
    
    
    
    @IBAction func faceBookLoginButtonClicked() {
        
        FaceBookHelper.sharedInstance.logIn(self)
    }
    
    @IBAction func twitterLoginButtonClicked() {
        
        TwitterHelper.logIn(self)
    }
    
    @IBAction func linkedInLoginButtonClicked() {
        
        UtilsLiknedInHelper.logIn(self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logInFBSuccess(data: NSDictionary) {
        
        User.currentUser.initFromFBData(data, controller: self)
        NSLog("facebook login success: %@", User.currentUser.allParams())
    }
    
    func logInTWSuccess(data: NSDictionary) {
        
        User.currentUser.initFromTWData(data, controller: self)
        NSLog("twitter login success: %@", User.currentUser.allParams())
    }
    
    func logInLKSuccess(data: NSDictionary) {
        
        User.currentUser.initFromLKData(data, controller: self)
        NSLog("linkedIn login success: %@", User.currentUser.allParams())
    }
    
    func logInGoogleSuccess(data: NSDictionary) {
        
        User.currentUser.initFromGoogleData(data, controller: self)
        NSLog("google login success: %@", User.currentUser.allParams())
    }
}

