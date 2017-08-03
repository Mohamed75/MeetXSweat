//
//  MXSWellComeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import PickerView


private let kJobButtonText       = "MON JOB"
private let kDomaineButtonText   = "MON DOMAINE"
private let kSportButtonText     = "MES SPORTS"


private let kAlertTitle     = "Image Source"
private let kAlertButton1   = "Cancel"
private let kAlertButton2   = "Camera"
private let kAlertButton3   = "Photo Roll"


private let kPopUpMessage   = "Veuillez choisir votre job, domaine et sport!"



/**
 *  This class was designed and implemented to provide a WellCome ViewController where you need to enter your Profession, Profession Type and Sport.
 
 - superClass:  MXSViewController.
 - classdesign  Observer.
 - coclass      UserViewModel.
 - helper       Utils.
 */

class MXSWellComeViewController: MXSViewController, PickerViewDataSource, PickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    @IBOutlet weak var jobButton: UIButton!
    @IBOutlet weak var domaineButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    
    @IBOutlet weak var pickerView: PickerView!
    @IBOutlet weak var pickerViewTopLayout: NSLayoutConstraint!
    
    
    fileprivate var dataArray       = FireBaseDataManager.sharedInstance.professions
    fileprivate var selectedButton  = 1 // 1 profession, 2 sport, 3 domaine
    
    
    fileprivate let imagePicker     = UIImagePickerController()
    fileprivate var updateUserImage = false
    
    
    
    
    func customPickerView() {
       
        pickerView.dataSource   = self
        pickerView.delegate     = self
        pickerView.scrollingStyle = .infinite
        pickerView.selectionStyle = .overlay
        pickerView.selectionOverlay.backgroundColor = Constants.MainColor.kSpecialColorClear
        pickerView.selectionOverlay.alpha = 1
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height {
            pickerViewTopLayout.constant = -80
        }
    }
    
    
    // MARK: - *** View lifecycle ***
    
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
        jobButton.setTitle(kJobButtonText, for: UIControlState())
        MXSViewController.customButton(domaineButton)
        domaineButton.setTitle(kDomaineButtonText, for: UIControlState())
        MXSViewController.customButton(sportButton)
        sportButton.setTitle(kSportButtonText, for: UIControlState())
        MXSViewController.customButton(letsGoButton)
        
        customPickerView()
        
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
    }
    
    // MARK: - *** DeInitialization ***
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.sports), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.professions), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.domaines), object: nil)
    }
    
    func userImageViewClicked() {
        
        let actionSheet = UIAlertController(title: kAlertTitle, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: kAlertButton1, style: UIAlertActionStyle.cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: kAlertButton2, style: UIAlertActionStyle.default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: kAlertButton3, style: UIAlertActionStyle.default, handler: { [weak self] action -> Void in
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
    
    // MARK: - *** Notifications Observer ***
    
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
    
    // MARK: - *** Button Clicked ***
    
    @IBAction func jobButtonClicked(_ sender: AnyObject) {
        
        selectedButton  = 1
        dataArray = FireBaseDataManager.sharedInstance.professions
        pickerView.isHidden = false
        pickerView.reloadPickerView()
    }
    
    @IBAction func domaineButtonClcked(_ sender: AnyObject) {
        
        selectedButton  = 3
        dataArray = FireBaseDataManager.sharedInstance.domaines
        pickerView.isHidden = false
        pickerView.reloadPickerView()
    }
    
    @IBAction func sportButtonClicked(_ sender: AnyObject) {
        
        selectedButton  = 2
        dataArray = FireBaseDataManager.sharedInstance.sports
        pickerView.isHidden = false
        pickerView.reloadPickerView()
    }
    
    @IBAction func letsGoButtonClicked(_ sender: AnyObject) {
        
        guard let job = jobButton.titleLabel?.text, let sport = sportButton.titleLabel?.text, let domaine = domaineButton.titleLabel?.text else {
            return
        }
        
        if (job != kJobButtonText && sport != kSportButtonText && domaine != kDomaineButtonText) {
        
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
            
            var frame = tabBarController?.view.frame
            frame?.size.height -= 50
            tabBarController?.view.frame = frame!
            
            let tuttorialViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.wellCome, viewControllerId: Ressources.StoryBooardsIdentifiers.tuttorialId)
            navigationController?.viewControllers = [tuttorialViewController]
            
        } else {
            MXSViewController.showInformatifPopUp(kPopUpMessage)
            pickerView.isHidden = false
        }
    }
    
    // MARK: - *** NavigationBar Button Actions ***
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        pickerView.isHidden = true
        view.endEditing(true)
        
        guard let job = jobButton.titleLabel?.text else {
            return
        }
        guard let sport = sportButton.titleLabel?.text else {
            return
        }
        guard let domaine = domaineButton.titleLabel?.text else {
            return
        }
        if (job != kJobButtonText && sport != kSportButtonText && domaine != kDomaineButtonText) {
            letsGoButtonClicked(letsGoButton)
        }
    }
    
    
    // MARK: - *** ImagePickerController ***
    
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
    
}


// MARK: - *** PickerView Delegate ***

extension MXSWellComeViewController {
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        let item = dataArray[index]
        return item
    }
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height {
            return 40
        }
        return 45.0
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        if highlighted {
            label.textColor = .black
        } else {
            label.textColor = .lightGray
        }
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        
        switch selectedButton {
        case 1:
            jobButton.setTitle(dataArray[index], for: UIControlState())
            break
        case 2:
            sportButton.setTitle(dataArray[index], for: UIControlState())
            break
        case 3:
            domaineButton.setTitle(dataArray[index], for: UIControlState())
            break
        default:
            break
        }
        pickerView.reloadPickerView()
    }
}
