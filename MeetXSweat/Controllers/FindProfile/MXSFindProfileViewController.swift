//
//  MXSFindProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import PickerView


/**
 *  This class was designed and implemented to provide a ViewController to find Persons by their Profession or Profession Type.
 
 - superClass:  MXSViewController.
 - classdesign  Inheritance.
 - coclass      MXSFindManager, FireBaseDataManager.
 - helper       Utils.
 */


class MXSFindProfileViewController: MXSViewController, PickerViewDataSource, PickerViewDelegate {
    
    // A property to setUp the viewController as user profile gettering data or findby viewController
    var editable: Bool = false
    
    @IBOutlet weak var topView: MXSTopView!
    
    @IBOutlet weak var metierLabel: UILabel!
    @IBOutlet weak var domaineLabel: UILabel!
    
    @IBOutlet weak var validerButton: UIButton!
    
    
    // A property to save the selecetd label (domaine or metier)
    fileprivate var selectedLabel   = 1
    
    fileprivate var savedDomaine = ""
    fileprivate var savedMetier  = ""
    
    
    
    @IBOutlet weak var pickerView: PickerView!
    @IBOutlet weak var pickerViewTopLayout: NSLayoutConstraint!
    @IBOutlet weak var pickerViewBottomLayout: NSLayoutConstraint!
    
    // The pickerView data source
    fileprivate var dataArray       = FireBaseDataManager.sharedInstance.domaines
    
    
    
    // MARK: - *** Initialization ***
    
    // The MXSFindProfileViewController shared instance
    static let sharedInstance = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
    
    
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.topView.topLabel.text   = "TROUVEZ DES PROFILS PRO"
        self.topView.imageView.image = UIImage(named: "Participants")
        
        if !editable {
            addBarButtonItem()
            title = Strings.NavigationTitle.rechercher
        }
        addValiderButton()
        
        
        customLabel(metierLabel)
        Utils.addTapGestureToView(metierLabel, target: self, selectorString: "selectMetierLabel")
        
        customLabel(domaineLabel)
        Utils.addTapGestureToView(domaineLabel, target: self, selectorString: "selectDomaineLabel")
        
        
        customPickerView()
        
        if !editable {
            
            NotificationCenter.default.addObserver(self, selector: Constants.FBNotificationSelector.domaines, name: NSNotification.Name(rawValue: Constants.FBNotificationName.domaines), object: nil)
            NotificationCenter.default.addObserver(self, selector: Constants.FBNotificationSelector.professions, name: NSNotification.Name(rawValue: Constants.FBNotificationName.professions), object: nil)
        } else {
            refreshView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        savedMetier  = ""
        savedDomaine = ""
        MXSFindManager.sharedInstance.findBy = FindBy.profile
        selectMetierLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - *** DeInitialization ***
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.domaines), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.FBNotificationName.professions), object: nil)
    }
    
    override func refreshView() {
        
        dispatch_later(0.01) { [weak self] in
            guard let this = self else {
                return
            }
            this.selectMetierLabel()
            this.pickerView.reloadPickerView()
        }
    }
    
    // MARK: - *** SetUp subView ***
    
    private func customLabel(_ label: UILabel) {
        
        label.layer.borderColor     = Constants.MainColor.kSpecialColor.cgColor
        label.layer.borderWidth     = 1
        label.layer.cornerRadius    = Constants.Cell.cornerRadius
        label.clipsToBounds = true
    }
    
    private func customPickerView() {
        
        pickerView.dataSource   = self
        pickerView.delegate     = self
        pickerView.scrollingStyle = .infinite
        pickerView.selectionStyle = .overlay
        pickerView.selectionOverlay.backgroundColor = Constants.MainColor.kSpecialColorClear
        pickerView.selectionOverlay.alpha = 1
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height {
            pickerViewTopLayout.constant = 20
            pickerViewBottomLayout.constant = 20
        }
    }
    
    
    // MARK: - *** Labels Actions ***
    
    internal func selectMetierLabel() {
        
        metierLabel.textColor = UIColor.white
        metierLabel.backgroundColor = Constants.MainColor.kSpecialColor
        selectedLabel = 1
        domaineLabel.textColor = Constants.MainColor.kSpecialColor
        domaineLabel.backgroundColor = UIColor.white
        
        dataArray = FireBaseDataManager.sharedInstance.professions
        pickerView.reloadPickerView()
    }
    
    internal func selectDomaineLabel() {
        
        domaineLabel.textColor = UIColor.white
        domaineLabel.backgroundColor = Constants.MainColor.kSpecialColor
        selectedLabel = 2
        metierLabel.textColor = Constants.MainColor.kSpecialColor
        metierLabel.backgroundColor = UIColor.white
        
        dataArray = FireBaseDataManager.sharedInstance.domaines
        pickerView.reloadPickerView()
    }
    
    
    
    // MARK: - *** Notifications Observer ***
    
    internal func selectorDomaineUpdated() {
        
        if selectedLabel == 2 {
            selectDomaineLabel()
        }
    }
    
    internal func selectorProfessionUpdated() {
        
        if selectedLabel == 1 {
            selectMetierLabel()
        }
    }
    
    
    // MARK: - *** NavigationBar Button Actions ***
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        if !savedMetier.isEmpty || !savedDomaine.isEmpty {
            if !editable {
                validerButton.sendActions(for: .touchUpInside)
            } else {
                
                if !savedMetier.isEmpty {
                    User.currentUser.profession = savedMetier
                }
                if !savedDomaine.isEmpty  {
                    User.currentUser.domaine = savedDomaine
                }
                User.currentUser.updatePersonOnDataBase(nil)
                if let navigationController = navigationController {
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func validerButtonClicked(_ sender: AnyObject) {
        
        if selectedLabel == 1 {
            MXSFindManager.sharedInstance.profession = savedMetier
            MXSFindManager.sharedInstance.domaine = ""
        } else {
            MXSFindManager.sharedInstance.profession = ""
            MXSFindManager.sharedInstance.domaine = savedDomaine
        }
    }
    
}


// MARK: - *** PickerView Delegate ***

extension MXSFindProfileViewController {
    
    internal func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return dataArray.count
    }
    
    internal func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        let item = dataArray[index]
        return item
    }
    
    internal func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        
        if ScreenSize.currentHeight == ScreenSize.iphone4Height {
            return 40
        }
        return 45.0
    }
    
    internal func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        if highlighted {
            label.textColor = .black
        } else {
            label.textColor = .lightGray
        }
    }
    
    internal func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        
        switch selectedLabel {
        case 1:
            savedMetier = dataArray[index]
            break
        case 2:
            savedDomaine = dataArray[index]
            break
        default:
            break
        }
        pickerView.reloadPickerView()
    }
}
