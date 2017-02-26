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
    
    
    fileprivate var dataArray       = FireBaseDataManager.sharedInstance.professions
    fileprivate var selectedButton  = 1 // 1 profession, 2 sport, 3 domaine
    fileprivate let pickerView      = UIPickerView()
    
    
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var updateUserImage = false
    
    
    
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
        jobButton.setTitle(jobButtonText, for: UIControlState())
        MXSViewController.customButton(domaineButton)
        domaineButton.setTitle(domaineButtonText, for: UIControlState())
        MXSViewController.customButton(sportButton)
        sportButton.setTitle(sportButtonText, for: UIControlState())
        MXSViewController.customButton(letsGoButton)
        
        MXSPickerView.initPickerView(pickerView, controller: self, scale: false)
        
        UserViewModel.setUserImageView(userImageView, person: User.currentUser)
        
        Utils.addTapGestureToView(userImageView, target: self, selectorString: "userImageViewClicked")   
        
        NotificationCenter.default.addObserver(self, selector: Constants.FBNotificationSelector.sports, name: NSNotification.Name(rawValue: Constants.FBNotificationName.sports), object: nil)
        NotificationCenter.default.addObserver(self, selector: Constants.FBNotificationSelector.professions, name: NSNotification.Name(rawValue: Constants.FBNotificationName.professions), object: nil)
        NotificationCenter.default.addObserver(self, selector: Constants.FBNotificationSelector.domaines, name: NSNotification.Name(rawValue: Constants.FBNotificationName.domaines), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.sports), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.professions), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.domaines), object: nil)
    }
    
    func userImageViewClicked() {
        
        let actionSheet = UIAlertController(title: "Image Source", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Roll", style: UIAlertActionStyle.default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForPhotoRoll()
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func promptForPhotoRoll() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func promptForCamera() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
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
    
    @IBAction func jobButtonClicked(_ sender: AnyObject) {
        
        selectedButton  = 1
        dataArray = FireBaseDataManager.sharedInstance.professions
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func domaineButtonClcked(_ sender: AnyObject) {
        
        selectedButton  = 3
        dataArray = FireBaseDataManager.sharedInstance.domaines
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func sportButtonClicked(_ sender: AnyObject) {
        
        selectedButton  = 2
        dataArray = FireBaseDataManager.sharedInstance.sports
        MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
    }
    
    @IBAction func letsGoButtonClicked(_ sender: AnyObject) {
        
        guard let job = jobButton.titleLabel?.text, let sport = sportButton.titleLabel?.text, let domaine = domaineButton.titleLabel?.text else {
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
                if let image = this.userImageView.image, this.updateUserImage {
                    User.currentUser.setUserImage(image)
                }
            })
            
            let tuttorialViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.wellCome, viewControllerId: Ressources.StoryBooardsIdentifiers.tuttorialId)
            navigationController?.viewControllers = [tuttorialViewController]
            
        } else {
            MXSViewController.showInformatifPopUp("Veuillez choisir votre job, domaine et sport!")
            MXSPickerView.showPickerView(pickerView, controller: self, scale: false)
        }
    }
    
    override func validatButtonClicked(_ sender: AnyObject) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.contentMode = .scaleAspectFit
            userImageView.image = pickedImage
            updateUserImage = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Mark: --- PickerView ---
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if row < dataArray.count {
            let string = dataArray[row]
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.black])
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedButton {
        case 1:
            jobButton.setTitle(dataArray[row], for: UIControlState())
            break
        case 2:
            sportButton.setTitle(dataArray[row], for: UIControlState())
            break
        case 3:
            domaineButton.setTitle(dataArray[row], for: UIControlState())
            break
        default:
            break
        }
        pickerView.reloadAllComponents()
    }
    
}
