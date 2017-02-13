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
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    private var normalDayCellColor      = UIColor.whiteColor()
    private var previousDayCellColor    = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
    private var perviousMonthTextColor  = UIColor.blackColor()
    
    @IBInspectable var todayColor: UIColor!
    
    lazy var todayDate : String = {
        [weak self] in
        let aString = self!.c.stringFromDate(NSDate())
        return aString
        }()
    lazy var c : NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = kCalendarCellDateFormat
        
        return f
    }()
    
    
    // This function was added by me
    private func myCutoms(cellState: CellState, date: NSDate) {
        if cellState.dateBelongsTo != .ThisMonth {
            self.backgroundColor = previousDayCellColor
        }
        
        self.layer.cornerRadius = 0
        if (c.stringFromDate(date) == todayDate) {
            self.layer.cornerRadius = self.frame.size.width/2
            dayLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        
        todayColor = Constants.MainColor.kSpecialColor
        
        dayLabel.text =  cellState.text
        
        configureTextColor(cellState)
        
        // Setup Cell Background color
        self.backgroundColor = c.stringFromDate(date) == todayDate ? todayColor : normalDayCellColor
        
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
            //self.selectedView.layer.cornerRadius =  self.selectedView.frame.width  / 2
            //self.selectedView.hidden = false
            configureTextColor(cellState)
            self.imageView.image = UIImage(named: Ressources.SportsImages.starSelected)
            
        } else {
            self.imageView.image = nil
            if animateDeselection {
                configureTextColor(cellState)
                if selectedView.hidden == false {
                    selectedView.animateWithFadeEffect(withCompletionHandler: { [weak self] () -> Void in
                        guard let this = self else {
                            return
                        }
                        this.selectedView.hidden = true
                        this.selectedView.alpha = 1
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