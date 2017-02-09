//
//  MXSFindProfileViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import DrawerController


private let kPickerViewScale = (((UIScreen.mainScreen().bounds.size.height/480)-1)*2)+1


class MXSFindProfileViewController: MXSViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var metierLabel: UILabel!
    @IBOutlet weak var domaineLabel: UILabel!
    
    @IBOutlet weak var validerButton: UIButton!
    
    let emptyTextField = UITextField()
    
    var savedDomaine = ""
    var savedMetier  = ""
    
    var dataArray       = DummyData.getDomaines()
    var selectedLabel   = 1
    let pickerView      = UIPickerView()
    
    
    static let sharedInstance = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findProfile, viewControllerId: Ressources.StoryBooardsIdentifiers.findProfileId)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MSXFindManager.sharedInstance.findBy = FindBy.Profile
        
        addBarButtonItem()
        addValiderButton()
        
        self.title = Ressources.NavigationTitle.rechercher
        
        titleLabel.textColor = kSpecialColor
        titleLabel.layer.borderColor = kSpecialColor.CGColor
        titleLabel.layer.borderWidth = 1
        
        metierLabel.layer.borderColor = kSpecialColor.CGColor
        metierLabel.layer.borderWidth = 1
        metierLabel.layer.cornerRadius = 4
        metierLabel.clipsToBounds = true
        Utils.addTapGestureToView(metierLabel, target: self, selectorString: "selectMetierLabel")
        
        domaineLabel.layer.borderColor = kSpecialColor.CGColor
        domaineLabel.layer.borderWidth = 1
        domaineLabel.layer.cornerRadius = 4
        domaineLabel.clipsToBounds = true
        Utils.addTapGestureToView(domaineLabel, target: self, selectorString: "selectDomaineLabel")
        
        
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = false
        
        emptyTextField.inputView = pickerView
        
        pickerView.transform = CGAffineTransformMakeScale(kPickerViewScale, kPickerViewScale);
        
        
        if let drawerController = getAppDelegateWindow().rootViewController as? DrawerController {
            /*
            drawerController.drawerVisualStateBlock = { (drawerController, gestureRecognizer, value) -> Void in
                if drawerController.openSide == .Left {
                    self.subViewPanned()
                }
            }*/
            
            drawerController.gestureCompletionBlock = { (drawerController, gestureRecognizer) -> Void in
            
                if self.tabBarController?.selectedIndex != 0 {
                    return
                }
                if drawerController.openSide == .None {
                    self.showPickerView()
                } else {
                    self.subViewPanned()
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        selectMetierLabel()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        subViewPanned()
    }
    
    
    func showPickerView() {
        
        emptyTextField.becomeFirstResponder()
        self.tabBarController?.view.addSubview(pickerView)
        
        let x = (pickerView.frame.size.width-UIScreen.mainScreen().bounds.size.width)/2
        pickerView.frame = CGRectMake(-x, UIScreen.mainScreen().bounds.size.height - pickerView.frame.size.height - 50, pickerView.frame.size.width, pickerView.frame.size.height)
        
        if pickerView.subviews.count > 2 {
            pickerView.subviews[2].removeFromSuperview()
            let selectorIndicator = pickerView.subviews[1]
            selectorIndicator.frame = CGRect(x: x*(1/kPickerViewScale), y: selectorIndicator.frame.origin.y, width: 320, height: 35)
            selectorIndicator.backgroundColor = kSpecialColor
            pickerView.insertSubview(selectorIndicator, atIndex: 0)
        }
    }
    
    func subViewPanned() {
        pickerView.removeFromSuperview()
        self.view.endEditing(true)
    }
    
    
    func selectMetierLabel() {
        
        showPickerView()
        
        metierLabel.textColor = UIColor.whiteColor()
        metierLabel.backgroundColor = kSpecialColor
        selectedLabel = 1
        domaineLabel.textColor = kSpecialColor
        domaineLabel.backgroundColor = UIColor.whiteColor()
        
        dataArray = DummyData.getProfessions()
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
    }
    
    func selectDomaineLabel() {
        
        showPickerView()
        
        domaineLabel.textColor = UIColor.whiteColor()
        domaineLabel.backgroundColor = kSpecialColor
        selectedLabel = 2
        metierLabel.textColor = kSpecialColor
        metierLabel.backgroundColor = UIColor.whiteColor()
        
        dataArray = DummyData.getDomaines()
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
    }
    
    
    
    override func togleMenuButton() {
        
        if self.evo_drawerController!.openSide == .None {
            subViewPanned()
        } else {
            showPickerView()
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
        
        if row == pickerView.selectedRowInComponent(0) {
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
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