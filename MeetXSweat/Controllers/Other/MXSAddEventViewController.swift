//
//  MXSAddEventViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit

/**
 *  This class was designed and implemented to provide a Create Event/Sport ViewController.
 
 - superClass:  MXSViewController.
 - helper       Utils.
 */

class MXSAddEventViewController: MXSViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    
    fileprivate let datePickerView  = UIDatePicker()
    fileprivate let sportPickerView = UIPickerView()
    
    fileprivate let dateFormatter   = DateFormatter()
    
    fileprivate let emptyDateTextField  = UITextField()
    fileprivate let emptySportTextField = UITextField()
    
    fileprivate var sports = FireBaseDataManager.sharedInstance.sports
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        Utils.addTapGestureToView(view, target: self, selectorString: kEndEditingSelectorString)
        
        super.viewDidLoad()
        
        emptyDateTextField.inputView = datePickerView
        view.addSubview(emptyDateTextField)
        
        emptySportTextField.inputView = sportPickerView
        view.addSubview(emptySportTextField)
        
        dateFormatter.dateFormat = kDateFormat
        
        datePickerView.minimumDate = Date()
        datePickerView.addTarget(self, action: #selector(MXSAddEventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateTextField.delegate = self
        
        sportPickerView.delegate    = self
        sportTextField.delegate     = self
    }
    
    // MARK: - *** FireBase Save Event ***
    
    func creatEvent() {
        
        let event = Event()
        if let name = self.nameTextField.text {
            event.name = name
        }
        event.adress = self.adressTextField.text
        if let date = self.dateTextField.text {
            event.date = date
        }
        if let description = self.descriptionTextField.text {
            event.aDescription = description
        }
        if let sport = self.sportTextField.text {
            event.sport = sport
        }
        event.persons = [User.currentUser.email]
        event.saveEventToDataBase()
    }
    
    // MARK: - *** Button Actions ***
    
    @IBAction func validerButtonClicked(_ sender: AnyObject) {
        
        var isAllFieldsFull = true
        if self.nameTextField.text?.characters.count == 0 {
            isAllFieldsFull = false
        }
        if self.adressTextField.text?.characters.count == 0 {
            isAllFieldsFull = false
        }
        if self.dateTextField.text?.characters.count == 0 {
            isAllFieldsFull = false
        }
        if self.descriptionTextField.text?.characters.count == 0 {
            isAllFieldsFull = false
        }
        if self.sportTextField.text?.characters.count == 0 {
            isAllFieldsFull = false
        }
        
        if isAllFieldsFull == false {
            MXSViewController.showInformatifPopUp(Strings.Alert.fillAllFieldsMessage)
            return
        }
        
        creatEvent()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeButtonClicked(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        self.dateTextField.text = dateFormatter.string(from: datePickerView.date)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.dateTextField:
            dateTextField.text = dateFormatter.string(from: datePickerView.date)
            emptyDateTextField.becomeFirstResponder()
            return false
        case self.sportTextField:
            if sportTextField.text == "" {
                sportTextField.text = sports.first
            }
            emptySportTextField.becomeFirstResponder()
            return false
        default:
            break
        }
        return true
    }
}


// MARK: - *** PickerView Delegate ***

extension MXSAddEventViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sports.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sports[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportTextField.text = sports[row]
    }
}
