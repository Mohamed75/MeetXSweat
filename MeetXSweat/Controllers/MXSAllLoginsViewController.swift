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
        
        User.currentUser.initFromFBData(data)
        print("facebook login success:", User.currentUser.allParams())
        self.navigationController?.viewDidLoad()
    }
    
    func logInTWSuccess(data: NSDictionary) {
        
        User.currentUser.initFromTWData(data)
        print("twitter login success:", User.currentUser.allParams())
        self.navigationController?.viewDidLoad()
    }
    
    func logInLKSuccess(data: NSDictionary) {
        
        User.currentUser.initFromLKData(data)
        print("linkedIn login success:", User.currentUser.allParams())
        self.navigationController?.viewDidLoad()
    }
    
    func logInGoogleSuccess(data: NSDictionary) {
        
        User.currentUser.initFromGoogleData(data)
        print("google login success:", User.currentUser.allParams())
        self.navigationController?.viewDidLoad()
    }
}

