//
//  MXSFindProfileViewController1.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let endEditingSelectorString = "endEditing"


class MXSFindProfileViewController1: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var domaineTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    let emptyTextField = UITextField()
    
    var dataArray = DummyData.getDomaines()
    var selectedTextField = 1
    let pickerView = UIPickerView()
    
    
    
    override func viewDidLoad() {
        
        Utils.addTapGestureToView(self.view, target: self, selectorString: endEditingSelectorString)
        super.viewDidLoad()
        self.view.addSubview(emptyTextField)
        
        pickerView.delegate = self
        emptyTextField.inputView = pickerView
        
        
        domaineTextField.delegate = self
        professionTextField.delegate = self
        experienceTextField.delegate = self
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedTextField {
        case 1:
            domaineTextField.text = dataArray[row]
            break
        case 2:
            professionTextField.text = dataArray[row]
            break
        case 3:
            experienceTextField.text = dataArray[row]
            break
        default:
            break
        }
    }
    
    func endEditing() {
       
        self.view.endEditing(true)
    }
    
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
        if let domaine = domaineTextField.text {
            FindProfileManager.sharedInstance.domaine = domaine
        }
        if let profession = professionTextField.text {
            FindProfileManager.sharedInstance.profession = profession
        }
        if let experience = experienceTextField.text {
            FindProfileManager.sharedInstance.experience = experience
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        switch textField {
        case domaineTextField:
            selectedTextField = 1
            dataArray = DummyData.getDomaines()
            domaineTextField.text = dataArray[0]
            break
        case professionTextField:
            selectedTextField = 2
            dataArray = DummyData.getProfessions()
            professionTextField.text = dataArray[0]
            break
        case experienceTextField:
            selectedTextField = 3
            dataArray = DummyData.getExperiences()
            experienceTextField.text = dataArray[0]
            break
        default:
            selectedTextField = 1
            dataArray = DummyData.getDomaines()
            break
        }
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
        
        
        emptyTextField.becomeFirstResponder()
        
        return false
    }
}