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
        
        title = Strings.NavigationTitle.planning
        
        titleLabel.text = Strings.Calendar.titleText
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = Constants.MainColor.kSpecialColor
        
        let topLine = UIView(frame: CGRect(x: 10, y: titleLabel.frame.size.height+15, width: view.frame.size.width-20, height: 1))
        topLine.backgroundColor = Constants.MainColor.kSpecialColor
        view.addSubview(topLine)
        
        
        let bottomLine = UIView(frame: CGRect(x: 7, y: stackView.frame.origin.y-1, width: view.frame.size.width-14, height: 1))
        bottomLine.backgroundColor = Constants.MainColor.kSpecialColor
        view.addSubview(bottomLine)
        
        
        calendarView.dataSource = self
        calendarView.delegate   = self
        calendarView.registerCellViewXib(file: Ressources.Xibs.calendarCellView)
        calendarView.cellInset  = CGPoint(x: 0, y: 0)
        calendarView.allowsMultipleSelection = true
        calendarView.reloadData()
        
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        MXSFindManager.sharedInstance.findBy = FindBy.date
    }
    
    override func refreshView() {
        
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calendarView.reloadData()
    }
    
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        var aDates = calendarView.selectedDates
        aDates.append(Date())
        
        MXSFindManager.sharedInstance.dates = aDates as [AnyObject]
        
        let viewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.embedSportsId)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    override func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month       = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName   = DateFormatter().monthSymbols[(month) % 12] // 0 indexed array
        let year        = testCalendar.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    
    @IBAction func next(_ sender: UIButton) {
        calendarView.scrollToSegment(.next) { [weak self] in
            
            guard let this = self else {
                return
            }
            this.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                this.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    @IBAction func previous(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous) { [weak self] in
            
            guard let this = self else {
                return
            }
            this.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                this.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }

}


