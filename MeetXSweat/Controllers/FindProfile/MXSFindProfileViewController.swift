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
    
    
    
    private var savedDomaine = ""
    private var savedMetier  = ""
    
    private var dataArray       = FireBaseDataManager.sharedInstance.domaines
    private var selectedLabel   = 1
    private let pickerView      = UIPickerView()
    
    
    static let sharedInstance = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
    
    
    func customLabel(label: UILabel) {
        
        label.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MSXFindManager.sharedInstance.findBy = FindBy.Profile
        
        addBarButtonItem()
        addValiderButton()
        
        self.title = Ressources.NavigationTitle.rechercher
        
        titleLabel.textColor = Constants.MainColor.kSpecialColor
        titleLabel.layer.borderColor = Constants.MainColor.kSpecialColor.CGColor
        titleLabel.layer.borderWidth = 1
        
        customLabel(metierLabel)
        Utils.addTapGestureToView(metierLabel, target: self, selectorString: "selectMetierLabel")
        
        customLabel(domaineLabel)
        Utils.addTapGestureToView(domaineLabel, target: self, selectorString: "selectDomaineLabel")
        
        
        MXSPickerView.initPickerView(pickerView, controller: self, scale: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.domaines, name: Constants.FBNotificationName.domaines, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.FBNotificationSelector.professions, name: Constants.FBNotificationName.professions, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        selectMetierLabel()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MXSPickerView.subViewPanned(pickerView, controller: self)
    }
    
    func selectMetierLabel() {
        
        metierLabel.textColor = UIColor.whiteColor()
        metierLabel.backgroundColor = Constants.MainColor.kSpecialColor
        selectedLabel = 1
        domaineLabel.textColor = Constants.MainColor.kSpecialColor
        domaineLabel.backgroundColor = UIColor.whiteColor()
        
        dataArray = FireBaseDataManager.sharedInstance.professions
        MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
    }
    
    func selectDomaineLabel() {
        
        domaineLabel.textColor = UIColor.whiteColor()
        domaineLabel.backgroundColor = Constants.MainColor.kSpecialColor
        selectedLabel = 2
        metierLabel.textColor = Constants.MainColor.kSpecialColor
        metierLabel.backgroundColor = UIColor.whiteColor()
        
        dataArray = FireBaseDataManager.sharedInstance.domaines
        MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
    }
    
    
    
    override func togleMenuButton() {
        
        if self.evo_drawerController!.openSide == .None {
            MXSPickerView.subViewPanned(pickerView, controller: self)
        } else {
            dispatch_later(1, closure: { [weak self] in
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
    
    override func validatButtonClicked(sender: AnyObject) {
        validerButton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
        if selectedLabel == 1 {
            FindProfileManager.sharedInstance.profession = savedMetier
        } else {
            FindProfileManager.sharedInstance.domaine = savedDomaine
        }
    }
    
}