//
//  MXSFindDateViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import JTAppleCalendar






class MXSFindDateViewController: MXSCalendarViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBarButtonItem()
        addValiderButton()
        
        titleLabel.text = Strings.Calendar.titleText
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.backgroundColor = Constants.MainColor.kSpecialColor
        
        let topLine = UIView(frame: CGRect(x: 10, y: titleLabel.frame.size.height+15, width: view.frame.size.width-20, height: 1))
        topLine.backgroundColor = Constants.MainColor.kSpecialColor
        view.addSubview(topLine)
        
        
        let bottomLine = UIView(frame: CGRect(x: 7, y: stackView.frame.origin.y-1, width: view.frame.size.width-14, height: 1))
        bottomLine.backgroundColor = Constants.MainColor.kSpecialColor
        view.addSubview(bottomLine)
        
        
        calendarView.dataSource = self
        calendarView.delegate   = self
        calendarView.registerCellViewXib(fileName: Ressources.Xibs.calendarCellView)
        calendarView.firstDayOfWeek = .Monday
        calendarView.cellInset  = CGPoint(x: 0, y: 0)
        calendarView.allowsMultipleSelection = true
        calendarView.reloadData()
        
        let currentDate = calendarView.currentCalendarDateSegment()
        self.setupViewsOfCalendar(currentDate.dateRange.start, endDate: currentDate.dateRange.end)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        MSXFindManager.sharedInstance.findBy = FindBy.Date
    }
    
    
    override func validatButtonClicked(sender: AnyObject) {
        
        FindDateManager.sharedInstance.dates = calendarView.selectedDates
        
        let viewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.embedSportsId)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    override func setupViewsOfCalendar(startDate: NSDate, endDate: NSDate) {
        let month = testCalendar.component(NSCalendarUnit.Month, fromDate: startDate)
        let monthName = NSDateFormatter().monthSymbols[(month) % 12] // 0 indexed array
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    
    
    @IBAction func next(sender: UIButton) {
        self.calendarView.scrollToNextSegment() {
            let currentSegmentDates = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentSegmentDates.dateRange.start, endDate: currentSegmentDates.dateRange.end)
        }
    }
    
    @IBAction func previous(sender: UIButton) {
        self.calendarView.scrollToPreviousSegment() {
            let currentSegmentDates = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentSegmentDates.dateRange.start, endDate: currentSegmentDates.dateRange.end)
        }
    }

}


