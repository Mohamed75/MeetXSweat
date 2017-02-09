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
    
    
    
    var savedDomaine = ""
    var savedMetier  = ""
    
    var dataArray       = DummyData.getDomaines()
    var selectedLabel   = 1
    let pickerView      = UIPickerView()
    
    
    static let sharedInstance = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
    
    
    func customLabel(label: UILabel) {
        
        label.layer.borderColor = kSpecialColor.CGColor
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
        
        titleLabel.textColor = kSpecialColor
        titleLabel.layer.borderColor = kSpecialColor.CGColor
        titleLabel.layer.borderWidth = 1
        
        customLabel(metierLabel)
        Utils.addTapGestureToView(metierLabel, target: self, selectorString: "selectMetierLabel")
        
        customLabel(domaineLabel)
        Utils.addTapGestureToView(domaineLabel, target: self, selectorString: "selectDomaineLabel")
        
        
        MXSPickerView.initPickerView(pickerView, controller: self, scale: true)
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
        metierLabel.backgroundColor = kSpecialColor
        selectedLabel = 1
        domaineLabel.textColor = kSpecialColor
        domaineLabel.backgroundColor = UIColor.whiteColor()
        
        dataArray = DummyData.getProfessions()
        MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
    }
    
    func selectDomaineLabel() {
        
        domaineLabel.textColor = UIColor.whiteColor()
        domaineLabel.backgroundColor = kSpecialColor
        selectedLabel = 2
        metierLabel.textColor = kSpecialColor
        metierLabel.backgroundColor = UIColor.whiteColor()
        
        dataArray = DummyData.getDomaines()
        MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
    }
    
    
    
    override func togleMenuButton() {
        
        if self.evo_drawerController!.openSide == .None {
            MXSPickerView.subViewPanned(pickerView, controller: self)
        } else {
            MXSPickerView.showPickerView(pickerView, controller: self, scale: true)
        }
        
        super.togleMenuButton()
    }
    
    
    // Mark: --- PickerView ---
    /*
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let aView = UIView(frame: CGRect(x:0, y:0, width: 320, height: 30))
        aView.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: aView.frame)
        label.textColor = UIColor.blackColor()
        label.text = dataArray[row]
        label.textAlignment = .Center
        aView.addSubview(label)
        return aView
    }*/
    
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