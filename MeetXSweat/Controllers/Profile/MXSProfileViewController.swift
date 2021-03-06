//
//  MXSProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let kNameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kCustomBlueColor,
    NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)
]

private let kProfessionAttributes = [
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName : UIFont.systemFont(ofSize: 16)
]

private let kAlertTitle        = "Image Source"
private let kAlertButtonTitle  = "Cancel"
private let kAlertButtonTitle2 = "Camera"
private let kAlertButtonTitle3 = "Photo Roll"

/**
 *  This class was designed and implemented to setUp a Profile ViewController.
 
 - superClass:  MXSViewController.
 - helper       Utils.
 */

class MXSProfileViewController: MXSViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    
    internal var person: Person!
    internal var editable: Bool = false
    
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var updateUserImage = false
    
    
    @IBOutlet weak var professionButton: UIButton!
    @IBOutlet weak var descriptionButton: UIButton!
    
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.title = Strings.NavigationTitle.profile
        
        imageView = UserImageView.addImageView(frame: CGRect(x: 20, y: 20, width: 160, height: 160), toView: self.view)
        UserViewModel.setUserImageView(imageView, person: person)
        
        if editable {
            addBarButtonItem()
            Utils.addTapGestureToView(imageView, target: self, selectorString: "userImageViewClicked")
            contactButton.isHidden = true
        } else {
            professionButton.isHidden     = true
            descriptionButton.isHidden    = true
        }
        
        if let eventsCollectionViewController = childViewControllers.first as? MXSEventsCollectionViewController {
            
            eventsCollectionViewController.events = person.getEvents()
            eventsCollectionViewController.fromProfileViewController = true
        }
        contactButton.setTitleColor(Constants.MainColor.kSpecialColor, for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let name = person.aFullName()
        let professionDomaine = person.professionDomaine()
        let string = NSMutableAttributedString(string: name + "\n" + professionDomaine)
        string.addAttributes(kNameAttributes, range: NSRange(location: 0, length: name.characters.count))
        if !professionDomaine.isEmpty {
            string.addAttributes(kProfessionAttributes, range: NSRange(location: name.characters.count, length: professionDomaine.characters.count))
        }
        nameLabel.attributedText = string
        
        
        if person.personDescription == "" {
            descriptionButton.isHidden = true
        }
        descriptionLabel.text = person.personDescription
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if editable {
            
            if let image = imageView.image, updateUserImage {
                User.currentUser.setUserImage(image)
                updateUserImage = false
            }
        }
    }
    
    
    private func promptForPhotoRoll() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func promptForCamera() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - *** ImagePickerController ***
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            updateUserImage = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - *** Button Actions ***
    
    internal func userImageViewClicked() {
        
        let actionSheet = UIAlertController(title: kAlertTitle, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: kAlertButtonTitle, style: UIAlertActionStyle.cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: kAlertButtonTitle2, style: UIAlertActionStyle.default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: kAlertButtonTitle3, style: UIAlertActionStyle.default, handler: { [weak self] action -> Void in
            guard let this = self else {
                return
            }
            this.promptForPhotoRoll()
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func contacterButtonClicked(_ sender: AnyObject) {
        
        let between:[String] = [User.currentUser.email, person.email]
        let conversation: Conversation!
        
        
        let chatViewController = ChatViewController()
        
        if let aConversation = ConversationsDataManager.sharedInstance.getConversationBetweenPersons(between) {
            conversation = aConversation
        } else {
           conversation = Conversation()
        }
        conversation.persons = between
        chatViewController.conversation = conversation
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    @IBAction func professionButtonClicked(_ sender: AnyObject) {
        
        if let profileDescrtiptionViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId) as? MXSFindProfileViewController {
            
            profileDescrtiptionViewController.editable = true
            navigationController?.pushViewController(profileDescrtiptionViewController, animated: false)
        }
    }
    
    
    @IBAction func descriptionButtonClicked(_ sender: AnyObject) {
        
        if let profileDescrtiptionViewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.profile, viewControllerId: Ressources.StoryBooardsIdentifiers.ProfileDescriptionId) as? MXSProfileDescriptionViewController {
            profileDescrtiptionViewController.person = person
            navigationController?.pushViewController(profileDescrtiptionViewController, animated: true)
        }
    }
}
