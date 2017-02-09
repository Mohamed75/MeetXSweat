//
//  MXSWellComeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSWellComeViewController: MXSViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var userImageWidthConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var jobButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    
    
    var dataArray       = DummyData.getProfessions()
    var selectedButton  = 1
    let pickerView      = UIPickerView()
    
    
    let jobButtonText   = "MON JOB"
    let sportButtonText = "MES SPORTS"
    
    func customButton(button: UIButton) {
        button.backgroundColor = kSpecialColor
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        nameLabel.text = User.currentUser.fullName()
        
        self.title = Ressources.NavigationTitle.wellCome
        
        if UIScreen.mainScreen().bounds.size.height == 480 { //iPhone 4
            addValiderButton()
        }
        
        customButton(jobButton)
        jobButton.setTitle(jobButtonText, forState: .Normal)
        customButton(sportButton)
        sportButton.setTitle(sportButtonText, forState: .Normal)
        customButton(letsGoButton)
        
        MXSPickerView.initPickerView(pickerView, controller: self, scale: false)
        
        userImageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !User.currentUser.pictureUrl.isEmpty {
            userImageView.af_setImageWithURL(
                NSURL(string: User.currentUser.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .None
            )
            //userImageWidthConst.constant -= 10
            //userImageView.layer.cornerRadius = (userImageView.frame.width-10)/2
            userImageView.layer.cornerRadius = userImageView.frame.width/2
            userImageView.clipsToBounds = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
    @IBAction func jobButtonClicked(sender: AnyObject) {
        
        selectedButton  = 1
        dataArray = DummyData.getProfessions()
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func sportButtonClicked(sender: AnyObject) {
        
        selectedButton  = 2
        dataArray = DummyData.getSports()
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func letsGoButtonClicked(sender: AnyObject) {
        
        guard let job = jobButton.titleLabel?.text else {
            return
        }
        guard let sport = sportButton.titleLabel?.text else {
            return
        }
        if (job != jobButtonText && sport != sportButtonText) {
        
            User.currentUser.profession = job
            User.currentUser.sport = sport
            User.currentUser.updatePersonOnDataBase()
            
            NSUserDefaults.standardUserDefaults().setObject([User.currentUser.email: "false"], forKey: "FirstTime")
            self.navigationController?.viewDidLoad()
        }
    }
    
    override func validatButtonClicked(sender: AnyObject) {
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
    
    // Mark: --- PickerView ---
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = dataArray[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedButton {
        case 1:
            jobButton.setTitle(dataArray[row], forState: .Normal)
            break
        case 2:
            sportButton.setTitle(dataArray[row], forState: .Normal)
            break
        default:
            break
        }
        pickerView.reloadAllComponents()
    }
    
}