//
//  MXSProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let nameAttributes = [
    NSForegroundColorAttributeName: Constants.MainColor.kSpecialColor,
    NSFontAttributeName : UIFont.boldSystemFontOfSize(17)
]

private let professionAttributes = [
    NSForegroundColorAttributeName: UIColor.blackColor(),
    NSFontAttributeName : UIFont.systemFontOfSize(16)
]




class MXSProfileViewController: MXSViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {


    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    
    var person: Person!
    var editable: Bool = false
    
    private let imagePicker = UIImagePickerController()
    private var updateUserImage = false
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
        imageView.image = UIImage(named: Ressources.Images.userSansPhoto)
        if !User.currentUser.pictureUrl.isEmpty {
            imageView.af_setImageWithURL(
                NSURL(string: person.pictureUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .None
            )
            imageView.layer.cornerRadius = imageView.frame.width/2
            imageView.clipsToBounds = true
        }
        
        if editable {
            Utils.addTapGestureToView(imageView, target: self, selectorString: "userImageViewClicked")
        }
        
        let text = person.aFullName()
        let string = NSMutableAttributedString(string: text + "\n" + FindProfileManager.sharedInstance.profession)
        string.addAttributes(nameAttributes, range: NSRange(location: 0,length: text.characters.count))
        if !FindProfileManager.sharedInstance.profession.isEmpty {
            string.addAttributes(professionAttributes, range: NSRange(location: text.characters.count,length: FindProfileManager.sharedInstance.profession.characters.count))
        }
        nameLabel.attributedText = string
        
        
        self.descriptionLabel.text = "My temporary description"
        
        if let eventsCollectionViewController = self.childViewControllers[0] as? MXSEventsCollectionViewController {
            // should filter events personne (to be done)
            eventsCollectionViewController.events = FireBaseDataManager.sharedInstance.events
            eventsCollectionViewController.fromProfileViewController = true
        }
        contactButton.setTitleColor(Constants.MainColor.kSpecialColor, forState: .Normal)
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
    
    // Mark: --- ImagePickerController ---
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            updateUserImage = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func contacterButtonClicked(sender: AnyObject) {
        
        
        let between:[Person] = [User.currentUser, self.person]
        let conversation: Conversation!
        
        
        let chatViewController = ChatViewController()
        
        if let aConversation = ConversationsDataManager.sharedInstance.getConversationBetweenPersons(between) {
            conversation = aConversation
        } else {
           conversation = Conversation()
        }
        conversation.persons = between
        chatViewController.conversation = conversation
        self.navigationController?.pushViewController(chatViewController, animated: true)
        //self.presentViewController(chatViewController, animated: true, completion: nil)
    }
}
