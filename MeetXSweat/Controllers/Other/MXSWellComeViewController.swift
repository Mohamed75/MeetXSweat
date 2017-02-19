//
//  MXSWellComeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let jobButtonText   = "MON JOB"
private let sportButtonText = "MES SPORTS"


class MXSWellComeViewController: MXSViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    @IBOutlet weak var jobButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    
    
    private var dataArray       = FireBaseDataManager.sharedInstance.professions
    private var selectedButton  = 1
    private let pickerView      = UIPickerView()
    
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        nameLabel.text = User.currentUser.fullName()
        
        self.title = Ressources.NavigationTitle.wellCome
        
        if UIScreen.mainScreen().bounds.size.height == 480 { //iPhone 4
            addValiderButton()
        }
        
        MXSViewController.customButton(jobButton)
        jobButton.setTitle(jobButtonText, forState: .Normal)
        MXSViewController.customButton(sportButton)
        sportButton.setTitle(sportButtonText, forState: .Normal)
        MXSViewController.customButton(letsGoButton)
        
        MXSPickerView.initPickerView(pickerView, controller: self, scale: false)
        
        userImageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !User.currentUser.pictureUrl.isEmpty {
            userImageView.af_setImageWithURL(
                NSURL(string: User.currentUser.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .None
            )
            userImageView.layer.cornerRadius = userImageView.frame.width/2
            userImageView.clipsToBounds = true
        } 
            
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.sports, name: Constants.FBNotificationName.sports, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.professions, name: Constants.FBNotificationName.professions, object: nil)
        
        Utils.addTapGestureToView(userImageView, target: self, selectorString: "userImageViewClicked")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
    func userImageViewClicked() {
        
        let actionSheet = UIAlertController(title: "Image Source", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Roll", style: UIAlertActionStyle.Default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForPhotoRoll()
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    func promptForPhotoRoll() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func promptForCamera() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Mark: --- Notifications Observer ---
    
    func selectorSportUpdated() {
        if selectedButton == 2 {
            sportButtonClicked(NSObject())
        }
    }
    
    func selectorProfessionUpdated() {
        
        if selectedButton == 1 {
            jobButtonClicked(NSObject())
        }
    }
    
    // Mark: --- Button Clicked ---
    
    @IBAction func jobButtonClicked(sender: AnyObject) {
        
        selectedButton  = 1
        dataArray = FireBaseDataManager.sharedInstance.professions
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func sportButtonClicked(sender: AnyObject) {
        
        selectedButton  = 2
        dataArray = FireBaseDataManager.sharedInstance.sports
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
            User.currentUser.updatePersonOnDataBase({ (done) in
            })
            
            let tuttorialViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.wellCome, viewControllerId: Ressources.StoryBooardsIdentifiers.tuttorialId)
            self.navigationController?.viewControllers = [tuttorialViewController]
        }
    }
    
    override func validatButtonClicked(sender: AnyObject) {
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
    
    // Mark: --- ImagePickerController ---
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.contentMode = .ScaleAspectFit
            userImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.blackColor()])
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