//
//  MXSFindProfileViewController1.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/21/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


// Dummy Data
private let domaines = ["Informatique", "Medical", "Social", "bancaire"]
private let professions = ["Developer", "Project Manager", "Medecin", "Professeur"]
private let experiences = ["0-2", "2-5", "5-10", ">10"]


class MXSFindProfileViewController1: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var domaineTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    let emptyTextField = UITextField()
    
    var dataArray = domaines
    var selectedTextField = 1
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        
        Utils.addTapGestureToView(self.view, target: self, selectorString: "endEditing")
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
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        switch textField {
        case domaineTextField:
            selectedTextField = 1
            dataArray = domaines
            break
        case professionTextField:
            selectedTextField = 2
            dataArray = professions
            break
        case experienceTextField:
            selectedTextField = 3
            dataArray = experiences
            break
        default:
            selectedTextField = 1
            dataArray = domaines
            break
        }
        pickerView.reloadAllComponents()
        
        emptyTextField.becomeFirstResponder()
        
        return false
    }
}