//
//  MXSWellComeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

private let jobButtonText   = "MON JOB"
private let domaineButtonText = "MON DOMAINE"
private let sportButtonText = "MES SPORTS"


class MXSWellComeViewController: MXSViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    @IBOutlet weak var jobButton: UIButton!
    @IBOutlet weak var domaineButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    
    
    private var dataArray       = FireBaseDataManager.sharedInstance.professions
    private var selectedButton  = 1 // 1 profession, 2 sport, 3 domaine
    private let pickerView      = UIPickerView()
    
    
    private let imagePicker = UIImagePickerController()
    private var updateUserImage = false
    
    
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        nameLabel.text = User.currentUser.aFullName()
        
        self.title = Strings.NavigationTitle.wellComme
        imagePicker.delegate = self
        
        if ScreenSize.currentHeight <= ScreenSize.iphone5Height {
            addValiderButton()
        }
        
        Utils.addTapGestureToView(view, target: self, selectorString: Constants.SelectorsString.valider)
        
        MXSViewController.customButton(jobButton)
        jobButton.setTitle(jobButtonText, forState: .Normal)
        MXSViewController.customButton(domaineButton)
        domaineButton.setTitle(domaineButtonText, forState: .Normal)
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
        Utils.addTapGestureToView(userImageView, target: self, selectorString: "userImageViewClicked")   
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.sports, name: Constants.FBNotificationName.sports, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.professions, name: Constants.FBNotificationName.professions, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.domaines, name: Constants.FBNotificationName.domaines, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func selectorDomaineUpdated() {
        
        if selectedButton == 3 {
            jobButtonClicked(NSObject())
        }
    }
    
    // Mark: --- Button Clicked ---
    
    @IBAction func jobButtonClicked(sender: AnyObject) {
        
        selectedButton  = 1
        dataArray = FireBaseDataManager.sharedInstance.professions
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func domaineButtonClcked(sender: AnyObject) {
        
        selectedButton  = 3
        dataArray = FireBaseDataManager.sharedInstance.domaines
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
        guard let domaine = domaineButton.titleLabel?.text else {
            return
        }
        if (job != jobButtonText && sport != sportButtonText && domaine != domaineButtonText) {
        
            User.currentUser.profession = job
            User.currentUser.sport      = sport
            User.currentUser.domaine    = domaine
            User.currentUser.updatePersonOnDataBase({ [weak self] done in
                
                guard let this = self else {
                    return
                }
                if let image = this.userImageView.image where this.updateUserImage {
                    User.currentUser.setUserImage(image)
                }
            })
            
            let tuttorialViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.wellCome, viewControllerId: Ressources.StoryBooardsIdentifiers.tuttorialId)
            self.navigationController?.viewControllers = [tuttorialViewController]
            
        } else {
            MXSViewController.showInformatifPopUp("Veuillez choisir votre job, domaine, sport!")
            MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
        }
    }
    
    override func validatButtonClicked(sender: AnyObject) {
        MXSPickerView.subViewPanned(pickerView, controller: self)
        
        guard let job = jobButton.titleLabel?.text else {
            return
        }
        guard let sport = sportButton.titleLabel?.text else {
            return
        }
        guard let domaine = domaineButton.titleLabel?.text else {
            return
        }
        if (job != jobButtonText && sport != sportButtonText && domaine != domaineButtonText) {
            letsGoButtonClicked(letsGoButton)
        }
    }
    
    
    // Mark: --- ImagePickerController ---
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.contentMode = .ScaleAspectFit
            userImageView.image = pickedImage
            updateUserImage = true
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
        case 3:
            domaineButton.setTitle(dataArray[row], forState: .Normal)
            break
        default:
            break
        }
        pickerView.reloadAllComponents()
    }
    
}