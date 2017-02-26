//
//  CalendarViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/23/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import JTAppleCalendar


private let daySeconds: Double = 24*60*60


class MXSCalendarViewController: MXSViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate  {
    
    static let formatter = DateFormatter()
    var testCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        testCalendar.timeZone = TimeZone(abbreviation: "GMT")!
        MXSCalendarViewController.formatter.dateFormat = kDateFormat
        
        let firstDate = Date()
        let secondDate = firstDate.addingTimeInterval(12*31*daySeconds) // one year
        let numberOfRows = 6
        let aCalendar = Calendar.current // Properly configure your calendar to your time zone here
        
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
