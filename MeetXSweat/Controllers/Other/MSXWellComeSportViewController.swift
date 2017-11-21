//
//  MSXWellComeSportViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 11/14/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import PickerView


private let kTopTitleLabel = "QUEL SPORT PRATIQUEZ VOUS"


class MSXWellComeSportViewController: MXSViewController, PickerViewDataSource, PickerViewDelegate {

    
    @IBOutlet weak var pickerView: PickerView!
    @IBOutlet weak var topView: MXSTopView!
    
    
    // The pickerView data source
    fileprivate var dataArray       = FireBaseDataManager.sharedInstance.sports
    
    
    fileprivate var savedSport = ""
    
    
    private func customPickerView() {
        
        let overlayImage = UIImage(named:"blueLine")?.scaleImage(CGSize(width: self.view.frame.size.width, height: 40))
        
        pickerView.dataSource   = self
        pickerView.delegate     = self
        pickerView.scrollingStyle = .infinite
        pickerView.selectionStyle = .overlay
        pickerView.selectionOverlay.backgroundColor = UIColor(patternImage: overlayImage!)
        pickerView.selectionOverlay.alpha = 0.5
        pickerView.backgroundColor = Constants.MainColor.kBackGroundColor
    }
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = Strings.NavigationTitle.wellComme
        
        self.topView.draw(self.topView.frame)
        self.topView.topLabel.text = kTopTitleLabel
        
        customPickerView()
        
        addValiderButton()
    }
    
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.SportObserver.notification), object: savedSport)
        self.exitViewController(animated: false)
    }

}



// MARK: - *** PickerView Delegate ***

extension MSXWellComeSportViewController {
    
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
        
        label.textColor = .white
    }
    
    internal func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        
        savedSport = dataArray[index]
    }
}
