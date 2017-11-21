//
//  MXSWellComeViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 2/9/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let kJobButtonText       = "MON MÉTIER"
private let kSportButtonText     = "MES SPORTS"


private let kAlertTitle     = "Image Source"
private let kAlertButton1   = "Cancel"
private let kAlertButton2   = "Camera"
private let kAlertButton3   = "Photo Roll"


private let kPopUpMessageJob    = "Veuillez choisir votre métier"
private let kPopUpMessageSport  = "Veuillez choisir votre sport!"



/**
 *  This class was designed and implemented to provide a WellCome ViewController where you need to enter your Profession, Profession Type and Sport.
 
 - superClass:  MXSViewController.
 - classdesign  Observer.
 - coclass      UserViewModel.
 - helper       Utils.
 */

class MXSWellComeViewController: MXSViewController, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var jobButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    
    
    
    fileprivate let imagePicker     = UIImagePickerController()
    fileprivate var updateUserImage = false
    
    
    private var myJob: String?
    private var myDomaine: String?
    private var mySport: String?
    
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        nameLabel.text = User.currentUser.aFullName()
        nameLabel.textColor = Constants.MainColor.kCustomBlueColor
        
        self.title = Strings.NavigationTitle.wellComme
        
        imagePicker.delegate = self
        
        if ScreenSize.currentHeight <= ScreenSize.iphone5Height {
            addValiderButton()
        }
        
        Utils.addTapGestureToView(view, target: self, selectorString: Constants.SelectorsString.valider)
        
        MXSViewController.customButton(jobButton)
        jobButton.setTitle(kJobButtonText, for: UIControlState())
        MXSViewController.customButton(sportButton)
        sportButton.setTitle(kSportButtonText, for: UIControlState())
        
        
        UserViewModel.setUserImageView(userImageView, person: User.currentUser)
        
        Utils.addTapGestureToView(userImageView, target: self, selectorString: "userImageViewClicked")
        
        NotificationCenter.default.addObserver(self, selector: Constants.JobObserver.selector, name: NSNotification.Name(rawValue: Constants.JobObserver.notification), object: nil)
        NotificationCenter.default.addObserver(self, selector: Constants.SportObserver.selector, name: NSNotification.Name(rawValue: Constants.SportObserver.notification), object: nil)
    }
    
    // MARK: - *** DeInitialization ***
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.JobObserver.notification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.SportObserver.notification), object: nil)
    }
    
    // MARK: - *** UIImagePicker ***
    
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
    
    
    // MARK: - *** Observers Selectors ***
    
    func setJobDomaine(_ sender: Notification) {
        
        if let objects = sender.object as? [String] {
        
            myJob = objects.first
            myDomaine = objects.last
        }
    }
    
    func setSport(_ sender: Notification) {
        
        mySport = sender.object as? String
    }
    
    
    // MARK: - *** Button Clicked ***
    
    @IBAction func letsGoButtonClicked(_ sender: AnyObject) {
        
        guard let job = myJob, let domaine = myDomaine else {
            
            MXSViewController.showInformatifPopUp(kPopUpMessageJob)
            return
        }
        guard let sport = mySport else {
            MXSViewController.showInformatifPopUp(kPopUpMessageSport)
            return
        }
        
        
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
    }
    
    // MARK: - *** NavigationBar Button Actions ***
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        view.endEditing(true)
        
        guard let job = jobButton.titleLabel?.text else {
            return
        }
        guard let sport = sportButton.titleLabel?.text else {
            return
        }
        if (job != kJobButtonText && sport != kSportButtonText) {
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


