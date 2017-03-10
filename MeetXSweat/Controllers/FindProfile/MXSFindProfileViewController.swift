//
//  MXSFindProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit




class MXSFindProfileViewController: MXSViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var metierLabel: UILabel!
    @IBOutlet weak var domaineLabel: UILabel!
    
    @IBOutlet weak var validerButton: UIButton!
    
    @IBOutlet weak var findUserImageView: UIImageView!
    
    
    var editable: Bool = false
    
    
    fileprivate var savedDomaine = ""
    fileprivate var savedMetier  = ""
    
    fileprivate var dataArray       = FireBaseDataManager.sharedInstance.domaines
    fileprivate var selectedLabel   = 1
    fileprivate let pickerView      = UIPickerView()
    
    
    static let sharedInstance = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
    
    
    
    func customLabel(_ label: UILabel) {
        
        label.layer.borderColor = Constants.MainColor.kSpecialColor.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !editable {
            addBarButtonItem()
            title = Strings.NavigationTitle.rechercher
        } else {
            titleLabel.isHidden = true
            findUserImageView.isHidden = true
        }
        addValiderButton()
        
        titleLabel.textColor = Constants.MainColor.kSpecialColor
        titleLabel.layer.borderColor = Constants.MainColor.kSpecialColor.cgColor
        titleLabel.layer.borderWidth = 1
        
        
        customLabel(metierLabel)
        Utils.addTapGestureToView(metierLabel, target: self, selectorString: "selectMetierLabel")
        
        customLabel(domaineLabel)
        Utils.addTapGestureToView(domaineLabel, target: self, selectorString: "selectDomaineLabel")
        
        
        MXSPickerView.initPickerView(pickerView, controller: self, scale: true)
        
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
        
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
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
            this.pickerView.reloadAllComponents()
        }
    }
    
    func selectMetierLabel() {
        
        metierLabel.textColor = UIColor.white
        metierLabel.backgroundColor = Constants.MainColor.kSpecialColor
        selectedLabel = 1
        domaineLabel.textColor = Constants.MainColor.kSpecialColor
        domaineLabel.backgroundColor = UIColor.white
        
        dataArray = FireBaseDataManager.sharedInstance.professions
        if navigationController?.visibleViewController == self  && tabBarController?.selectedIndex == 0 {
            MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
        }
        if editable {
            MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
        }
    }
    
    func selectDomaineLabel() {
        
        domaineLabel.textColor = UIColor.white
        domaineLabel.backgroundColor = Constants.MainColor.kSpecialColor
        selectedLabel = 2
        metierLabel.textColor = Constants.MainColor.kSpecialColor
        metierLabel.backgroundColor = UIColor.white
        
        dataArray = FireBaseDataManager.sharedInstance.domaines
        if navigationController?.visibleViewController == self && tabBarController?.selectedIndex == 0 {
            MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
        }
        if editable {
            MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
        }
    }
    
    
    
    override func togleMenuButton() {
        
        if self.evo_drawerController!.openSide == .none {
            MXSPickerView.subViewPanned(pickerView, controller: self)
        } else {
            dispatch_later(0.2, closure: { [weak self] in
                guard let this = self else {
                    return
                }
                MXSPickerView.showPickerView(this.pickerView, controller: this, scale: true)
            })
        }
        
        super.togleMenuButton()
    }
    
    
    // Mark: --- Notifications Observer ---
    
    func selectorDomaineUpdated() {
        
        if selectedLabel == 2 {
            selectDomaineLabel()
        }
    }
    
    func selectorProfessionUpdated() {
        
        if selectedLabel == 1 {
            selectMetierLabel()
        }
    }
    
    
    // Mark: --- PickerView ---
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = dataArray[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedLabel {
        case 1:
            savedMetier = dataArray[row]
            break
        case 2:
            savedDomaine = dataArray[row]
            break
        default:
            break
        }
        pickerView.reloadAllComponents()
    }
    
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
