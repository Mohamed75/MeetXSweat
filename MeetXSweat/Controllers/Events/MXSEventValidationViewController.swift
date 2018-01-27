//
//  MXSEventValidationViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 1/27/18.
//  Copyright © 2018 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit


private let kTopDataText = "TA PARTICIPATION A ÉTÉ PRISE EN COMPTE \nSUR L'APPLICATION \n\nINFO ORGANISATEUR:"
private let kBottomDataText = "*VOIR EN DÉTAIL LES MODALITÉS \nD'INSCRIPTION DE L'ORGANISATION"

private let kButtonTitle1 = "Organisateur de l'event"
private let kButtonTitle2 = "Liens"

private let kButtonsWidthMargin: CGFloat = ScreenSize.currentWidth <= ScreenSize.iphone45Width ? 30 : 40

private let xLabels: CGFloat = 20

private let labelsWidth = ScreenSize.currentWidth - xLabels
private let labelsFont = ScreenSize.currentWidth <= ScreenSize.iphone45Width ? UIFont.systemFont(ofSize: 12) : UIFont.systemFont(ofSize: 15)

private let kTopDataLabelHeight: CGFloat = ScreenSize.currentWidth <= ScreenSize.iphone45Width ? 80 : 100
private let kBottomDataLabelHeight: CGFloat = 60
private let kButtonHeight: CGFloat = 50


private let kVerticalMargin: CGFloat = ScreenSize.currentWidth > ScreenSize.iphone6Width ? 20 : (ScreenSize.currentWidth == ScreenSize.iphone6Width ? 10 : 0)



class MXSEventValidationViewController: MXSViewController {
    
    internal var event: Event!
    
    @IBOutlet weak var topView: MXSTopView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = Strings.NavigationTitle.eventValidation
        
        self.topView.topLabel.text = self.event.sport.uppercased()
        
        self.infoView.layer.borderColor     = UIColor.white.cgColor
        self.infoView.layer.borderWidth     = 1
        self.infoView.layer.cornerRadius = Constants.Cell.cornerRadius
        
        self.dataView.layer.borderColor     = UIColor.white.cgColor
        self.dataView.layer.borderWidth     = 1
        self.dataView.layer.cornerRadius = Constants.Cell.cornerRadius
        
        let infoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelsWidth, height: self.infoView.frame.size.height))
        infoLabel.text = "INFO"
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor.white
        self.infoView.addSubview(infoLabel)
        
        
        var y: CGFloat = ScreenSize.currentWidth <= ScreenSize.iphone45Width ? 0 : 10
        let topDataLabel = UILabel(frame: CGRect(x: xLabels, y: y, width: labelsWidth, height: kTopDataLabelHeight))
        topDataLabel.text = kTopDataText
        topDataLabel.font = labelsFont
        topDataLabel.numberOfLines = 0
        topDataLabel.textColor = UIColor.white
        self.dataView.addSubview(topDataLabel)
        
        y += kTopDataLabelHeight + kVerticalMargin
        
        
        let organizerButton = UIButton(frame: CGRect(x: xLabels-10, y: y, width: labelsWidth-kButtonsWidthMargin, height: kButtonHeight))
        organizerButton.backgroundColor = Constants.MainColor.kCustomBlueColor
        organizerButton.addTarget(self, action: #selector(organizerButtonClicked), for: .touchUpInside)
        organizerButton.setTitle(kButtonTitle1, for: .normal)
        organizerButton.setTitleColor(UIColor.white, for: .normal)
        organizerButton.layer.cornerRadius = Constants.Cell.cornerRadius
        self.dataView.addSubview(organizerButton)
        
        y += kButtonHeight + 10 + kVerticalMargin
        
        let linksButton = UIButton(frame: CGRect(x: xLabels-10, y: y, width: labelsWidth-kButtonsWidthMargin, height: kButtonHeight))
        linksButton.backgroundColor = Constants.MainColor.kCustomBlueColor
        linksButton.addTarget(self, action: #selector(linksButtonClicked), for: .touchUpInside)
        linksButton.setTitle(kButtonTitle2, for: .normal)
        linksButton.setTitleColor(UIColor.white, for: .normal)
        linksButton.layer.cornerRadius = Constants.Cell.cornerRadius
        self.dataView.addSubview(linksButton)
        
        y += kButtonHeight + kVerticalMargin
        
        let bottomDataLabel = UILabel(frame: CGRect(x: xLabels, y: y, width: labelsWidth, height: kBottomDataLabelHeight))
        bottomDataLabel.text = kBottomDataText
        bottomDataLabel.font = labelsFont
        bottomDataLabel.numberOfLines = 0
        bottomDataLabel.textColor = UIColor.white
        self.dataView.addSubview(bottomDataLabel)
    }
    
    
    func organizerButtonClicked() {
        
        guard let url = URL(string: self.event.organizerLink) else {
            return
        }
        
        UIApplication.shared.openURL(url)
    }
    
    
    func linksButtonClicked() {
        
        guard let url = URL(string: self.event.otherLink) else {
            return
        }
        
        UIApplication.shared.openURL(url)
    }
    
}
