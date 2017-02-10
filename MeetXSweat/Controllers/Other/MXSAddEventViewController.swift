//
//  MXSAddEventViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/24/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


class MXSAddEventViewController: MXSViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    
    private let datePickerView  = UIDatePicker()
    private let sportPickerView = UIPickerView()
    
    private let dateFormatter = NSDateFormatter()
    
    private let emptyDateTextField  = UITextField()
    private let emptySportTextField = UITextField()
    
    private var sports = FireBaseDataManager.sharedInstance.sports
    
    
    override func viewDidLoad() {
        
        Utils.addTapGestureToView(self.view, target: self, selectorString: kEndEditingSelectorString)
        
        super.viewDidLoad()
        
        emptyDateTextField.inputView = datePickerView
        self.view.addSubview(emptyDateTextField)
        
        emptySportTextField.inputView = sportPickerView
        self.view.addSubview(emptySportTextField)
        
        dateFormatter.dateFormat = kDateFormat
        
        datePickerView.minimumDate = NSDate()
        datePickerView.addTarget(self, action: #selector(MXSAddEventViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        dateTextField.delegate = self
        
        sportPickerView.delegate    = self
        sportTextField.delegate     = self
    }
    
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
        event.persons = [User.currentUser]
        event.saveEventToDataBase()
    }
    
    
    @IBAction func validerButtonClicked(sender: AnyObject) {
        
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
            let alert = UIAlertController(title: Strings.Alert.alert, message: Strings.Alert.fillAllFieldsMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: Strings.Alert.ok, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        creatEvent()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        self.dateTextField.text = dateFormatter.stringFromDate(datePickerView.date)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        switch textField {
        case self.dateTextField:
            dateTextField.text = dateFormatter.stringFromDate(datePickerView.date)
            emptyDateTextField.becomeFirstResponder()
            return false
        case self.sportTextField:
            if sportTextField.text == "" {
                sportTextField.text = sports[0]
            }
            emptySportTextField.becomeFirstResponder()
            return false
        default:
            break
        }
        return true
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sports.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sports[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportTextField.text = sports[row]
    }
    
    func endEditing() {
        
        self.view.endEditing(true)
    }
}