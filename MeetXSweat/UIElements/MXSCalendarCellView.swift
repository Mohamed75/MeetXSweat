//
//  CalendarCellView.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import JTAppleCalendar


class MXSCalendarCellView: JTAppleDayCellView {
    
    @IBOutlet var selectedView: AnimationView!
    @IBOutlet var dayLabel: UILabel!
    
    var normalDayCellColor = UIColor.whiteColor()
    
    var perviousMonthTextColor = UIColor.grayColor()
    
    @IBInspectable var todayColor: UIColor!
    
    lazy var todayDate : String = {
        [weak self] in
        let aString = self!.c.stringFromDate(NSDate())
        return aString
        }()
    lazy var c : NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        
        return f
    }()
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        
        dayLabel.text =  cellState.text
        
        configureTextColor(cellState)
        
        // Setup Cell Background color
        self.backgroundColor = c.stringFromDate(date) == todayDate ? todayColor : normalDayCellColor
        
        // Setup cell selection status
        delayRunOnMainThread(0.0) {
            self.configueViewIntoBubbleView(cellState)
        }
        
        // Configure Visibility
        configureVisibility(cellState)
    }
    
    
    func cellSelectionChanged(cellState: CellState) {
        if cellState.isSelected == true {
            if selectedView.hidden == true {
                configueViewIntoBubbleView(cellState)
                selectedView.animateWithBounceEffect(withCompletionHandler: {
                })
            }
        } else {
            configueViewIntoBubbleView(cellState, animateDeselection: true)
        }
    }
    
    private func configureTextColor(cellState: CellState) {
        if cellState.dateBelongsTo == .ThisMonth {
            dayLabel.textColor = UIColor.blackColor()
        } else {
            dayLabel.textColor = perviousMonthTextColor
        }
    }
    
    private func configureVisibility(cellState: CellState) {
        if
            cellState.dateBelongsTo == .ThisMonth ||
                cellState.dateBelongsTo == .PreviousMonthWithinBoundary ||
                cellState.dateBelongsTo == .FollowingMonthWithinBoundary {
            self.hidden = false
        } else {
            self.hidden = false
        }
        
    }
    
    private func configueViewIntoBubbleView(cellState: CellState, animateDeselection: Bool = false) {
        if cellState.isSelected {
            self.selectedView.layer.cornerRadius =  self.selectedView.frame.width  / 2
            self.selectedView.hidden = false
            configureTextColor(cellState)
            
        } else {
            if animateDeselection {
                configureTextColor(cellState)
                if selectedView.hidden == false {
                    unowned let weakSelf = self
                    selectedView.animateWithFadeEffect(withCompletionHandler: { () -> Void in
                        weakSelf.selectedView.hidden = true
                        weakSelf.selectedView.alpha = 1
                    })
                }
            } else {
                selectedView.hidden = true
            }
        }
    }
}


class AnimationView: UIView {
    
    func animateWithFlipEffect(withCompletionHandler completionHandler:(()->Void)?) {
        AnimationClass.flipAnimation(self, completion: completionHandler)
    }
    func animateWithBounceEffect(withCompletionHandler completionHandler:(()->Void)?) {
        let viewAnimation = AnimationClass.BounceEffect()
        viewAnimation(self){ _ in
            completionHandler?()
        }
    }
    func animateWithFadeEffect(withCompletionHandler completionHandler:(()->Void)?) {
        let viewAnimation = AnimationClass.FadeOutEffect()
        viewAnimation(self) { _ in
            completionHandler?()
        }
    }
}