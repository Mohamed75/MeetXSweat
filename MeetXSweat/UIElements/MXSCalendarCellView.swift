//
//  CalendarCellView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import JTAppleCalendar


/**
 *  This class was designed and implemented to provide a Calender CellView
 
 - superClass:  JTAppleDayCellView.
 */

class MXSCalendarCellView: JTAppleDayCellView {
    
    @IBOutlet var selectedView: AnimationView!
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    
    
    fileprivate var normalDayCellColor      = UIColor.black
    fileprivate var kTodayColor             = UIColor.black
    fileprivate var previousDayCellColor    = UIColor.darkGray
    fileprivate var perviousMonthTextColor  = UIColor.white
    fileprivate var dayLabelTextColor       = UIColor.white
    fileprivate var selectedViewColor       = Constants.MainColor.kCustomBlueColor
    
    @IBInspectable var todayColor: UIColor!
    
    lazy var todayDate : String = {
        [weak self] in
        let aString = self!.c.string(from: Date())
        return aString
        }()
    lazy var c : DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = kCalendarCellDateFormat
        
        return f
    }()
    
    
    // This function was added by me
    fileprivate func myCutoms(_ cellState: CellState, date: Date) {
        if cellState.dateBelongsTo != .thisMonth {
            self.backgroundColor = previousDayCellColor
        }
        
        selectedView.isHidden = true
        selectedView.layer.cornerRadius = 0
        if (c.string(from: date) == todayDate) {
            selectedView.layoutIfNeeded()
            selectedView.layer.cornerRadius = selectedView.frame.size.width / 2
            dayLabel.textColor = dayLabelTextColor
            selectedView.isHidden = false
            selectedView.backgroundColor = selectedViewColor
        }
        
        if ScreenSize.currentWidth >= ScreenSize.iphone6Width {
            imageViewConstraint.constant = 8
        }
    }
    
    func setupCellBeforeDisplay(_ cellState: CellState, date: Date) {
        
        todayColor = kTodayColor
        
        dayLabel.text =  cellState.text
        
        configureTextColor(cellState)
        
        // Setup Cell Background color
        self.backgroundColor = c.string(from: date) == todayDate ? todayColor : normalDayCellColor
        
        myCutoms(cellState, date: date)
        
        // Setup cell selection status
        dispatch_later(0.0) { [weak self] in
            guard let this = self else {
                return
            }
            this.configueViewIntoBubbleView(cellState)
        }
        
        // Configure Visibility
        configureVisibility(cellState)
    }
    
    
    func cellSelectionChanged(_ cellState: CellState) {
        if cellState.isSelected == true {
            if selectedView.isHidden == true {
                configueViewIntoBubbleView(cellState)
                selectedView.animateWithBounceEffect(withCompletionHandler: nil)
            }
        } else {
            configueViewIntoBubbleView(cellState, animateDeselection: true)
        }
    }
    
    fileprivate func configureTextColor(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dayLabel.textColor = dayLabelTextColor
        } else {
            dayLabel.textColor = perviousMonthTextColor
        }
    }
    
    fileprivate func configureVisibility(_ cellState: CellState) {
        if
            cellState.dateBelongsTo == .thisMonth ||
                cellState.dateBelongsTo == .previousMonthWithinBoundary ||
                cellState.dateBelongsTo == .followingMonthWithinBoundary {
            self.isHidden = false
        } else {
            self.isHidden = false
        }
        
    }
    
    fileprivate func configueViewIntoBubbleView(_ cellState: CellState, animateDeselection: Bool = false) {
        if cellState.isSelected {
            //self.selectedView.layer.cornerRadius =  self.selectedView.frame.width  / 2
            //self.selectedView.hidden = false
            configureTextColor(cellState)
            
            if !self.selectedView.isHidden == false {
                self.imageView.image = UIImage(color: selectedViewColor)
                self.imageView.layer.cornerRadius = self.imageView.frame.width  / 2
                self.imageView.clipsToBounds = true
            } else {
                dayLabel.textColor = dayLabelTextColor
            }
            
        } else {
            self.imageView.image = nil
            /*
            if animateDeselection {
                configureTextColor(cellState)
                if selectedView.hidden == false {
                    selectedView.animateWithFadeEffect(withCompletionHandler: { [weak self] () -> Void in
                        guard let this = self else {
                            return
                        }
                        this.selectedView.hidden = true
                    })
                }
            } else {
                selectedView.hidden = true
            }*/
        }
    }
}


class AnimationView: UIView {
    
    func animateWithFlipEffect(withCompletionHandler completionHandler: FlipBlock?) {
        AnimationClass.flipAnimation(self, completion: completionHandler)
    }
    func animateWithBounceEffect(withCompletionHandler completionHandler: FlipBlock?) {
        let viewAnimation = AnimationClass.BounceEffect()
        viewAnimation(self){ _ in
            completionHandler?()
        }
    }
    func animateWithFadeEffect(withCompletionHandler completionHandler: FlipBlock?) {
        let viewAnimation = AnimationClass.FadeOutEffect()
        viewAnimation(self) { _ in
            completionHandler?()
        }
    }
}
