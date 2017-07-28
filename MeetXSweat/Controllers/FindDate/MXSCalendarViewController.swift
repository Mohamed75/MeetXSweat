//
//  CalendarViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import JTAppleCalendar

// A number of seconds by day
private let kDaySeconds: Double = 24*60*60
private let kYearSeconds: Double = 12*31*kDaySeconds


/**
 *  This class was designed and implemented to provide a Calendar ViewController.
 
 - superClass:  MXSViewController.
 - coclass      MXSCalendarCellView.
 */

class MXSCalendarViewController: MXSViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate  {
    
    static let formatter = DateFormatter()
    var setUpCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    
    
    // Mark: --- SetUp ---
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        setUpCalendar.timeZone = TimeZone(abbreviation: "GMT")!
        MXSCalendarViewController.formatter.dateFormat = kDateFormat
        
        let firstDate   = Date()
        let secondDate  = firstDate.addingTimeInterval(kYearSeconds) // one year
        let numberOfRows = 6
        let aCalendar   = Calendar.current // Properly configure your calendar to your time zone here
        
        return ConfigurationParameters(startDate: firstDate,
                                       endDate: secondDate,
                                       numberOfRows: numberOfRows,
                                       calendar: aCalendar,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: true)
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
    }
}


// Mark: --- JTAppleCalendarView Delegate ---

extension MXSCalendarViewController {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        
        (cell as! MXSCalendarCellView).setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as! MXSCalendarCellView).cellSelectionChanged(cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? MXSCalendarCellView)?.cellSelectionChanged(cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willResetCell cell: JTAppleDayCellView) {
        (cell as? MXSCalendarCellView)?.selectedView.isHidden = true
    }
}
