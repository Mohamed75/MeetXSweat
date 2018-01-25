//
//  MXSFindDateViewController.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 9/22/16.
//  Copyright © 2016 Mohamed BOUMANSOUR. All rights reserved.
//

import UIKit
import JTAppleCalendar



/**
 *  This class was designed and implemented to provide a ViewController to find events by date.
 
 - superClass:  MXSCalendarViewController.
 - coclass      MXSFindManager.
 */

class MXSFindDateViewController: MXSCalendarViewController {
    
    
    @IBOutlet weak var topView: MXSTopView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK: - *** View lifecycle ***
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBarButtonItem()
        addValiderButton()
        
        title = Strings.NavigationTitle.planning
        
        self.topView.topLabel.text = Strings.Calendar.titleText
        self.topView.imageView.image = UIImage(named: "date")
       
        
        
        let topLineView = UIImageView(image: Ressources.blueLineImage)
        topLineView.frame = CGRect(x: 0, y: topView.frame.size.height+50, width: view.frame.size.width, height: 2)
        view.addSubview(topLineView)
        
        let dateFormatter   = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateStyle = DateFormatter.Style.long
        self.dateLabel.text = dateFormatter.string(from: Date())
        
        
        let bottomLineView = UIImageView(image: Ressources.blueLineImage)
        bottomLineView.frame = CGRect(x: 0, y: stackView.frame.size.height+3, width: view.frame.size.width, height: 2)
        stackView.addSubview(bottomLineView)
        
        
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
    
    // MARK: - *** NavigationBar Button Actions ***
    
    override func validatButtonClicked(_ sender: AnyObject) {
        
        var aDates = calendarView.selectedDates
        aDates.append(Date())
        
        MXSFindManager.sharedInstance.dates = aDates as [AnyObject]
        
        let viewController = Utils.loadViewControllerFromStoryBoard(Ressources.StoryBooards.findSport, viewControllerId: Ressources.StoryBooardsIdentifiers.embedSportsId)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - *** Setup Calendar Views ***
    
    override func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month       = setUpCalendar.dateComponents([.month], from: startDate).month!
        let monthName   = DateFormatter().monthSymbols[(month) % 12] // 0 indexed array
        let year        = setUpCalendar.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    
    
    // MARK: - *** Button Actions ***
    
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


