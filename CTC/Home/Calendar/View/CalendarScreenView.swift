//
//  CalendarView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import Lottie

class CalendarView: UIView {
    
    private var viewModel = CalendarScreenViewModel()
    private let cellSpacingHeight: CGFloat = 15
    var events: [Event]?
    private var finishedLoadingInitialTableCells = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadingAnimation.play()
        self.addSubview(loadingAnimation)
        
        viewModel.getAllEvents() { (events: [Event] ) in // TODO: Fix the completion handler so that the spinny thing doesn't keeo going when no events are returned
            self.events = events
            self.calendarListTableView.reloadData()
            self.loadingAnimation.isHidden = true
        }
        updateFrames(frame: frame)
        self.addSubview(titleLabel)
    }
    
    private let loadingAnimation: AnimationView = {
        let animationView = AnimationView(name: "loading")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.0
        animationView.loopMode = .loop
        return animationView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming Events"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.layer.shadowOpacity = 0.23
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowColor = UIColor.black.cgColor
        return label
    }()
    private lazy var calendarListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.layer.cornerRadius = 5
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    public func updateFrames(frame: CGRect){
        self.frame = frame
        titleLabel.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: titleLabel.intrinsicContentSize.height)
        calendarListTableView.frame =  CGRect(x: 10, y: titleLabel.frame.maxY + 20, width: frame.width - 20, height: frame.height - calendarListTableView.frame.origin.y)
        loadingAnimation.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingAnimation.center = CGPoint(x: calendarListTableView.center.x, y: calendarListTableView.center.y - titleLabel.frame.maxY + 20)
        
        self.setNeedsDisplay()
        titleLabel.setNeedsDisplay()
        calendarListTableView.setNeedsDisplay()
    }
    
    public func showCalendar(){
        self.addSubview(calendarListTableView)
        updateFrames(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.eventCount
        return self.viewModel.eventCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150 + 10 // + cell spacing
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
        cell.cellCalendarDelegate = self
        // This should all be moved
        if viewModel.eventCount > 0 {
            guard let data = events?[indexPath.row % viewModel.eventCount] else {
                cell.event = Event()
                cell.isHidden = true
                return cell
            }
            cell.event = data
            cell.contentView.alpha = 0
            cell.updateUI()
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true

        /*
            Code for animating the loading of cells
         */
        var lastInitialDisplayableCell = false
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if viewModel.eventCount > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }

        if !finishedLoadingInitialTableCells {
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

            UIView.animate(
                withDuration: 0.3,
                delay: 0.05 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
        
        UIView.animate(withDuration: 0.4) {
            cell.contentView.alpha = 1
        }
    }
}


// TODO: Fix delegate
extension CalendarView: calendarDelegate {
    func addToCalendar(title: String, eventStartDate: Date, eventEndDate: Date, location: String, detail: String) {
        self.viewModel.addToCalendar(title: title, eventStartDate: eventStartDate, eventEndDate: eventEndDate, location: location, detail: detail) { ( success: Bool, event: Event? ) in
            
            let message: String!
            let title: String!
            var actions = [UIAlertAction]()
            var negativeOffset = 0
            
            if success && event != nil {
                title = "Event Added To Calendar!"
                message = "Event successfully added to your calendar, see you there! Would you like to be notified before the events starts?"
                
                let thirtyMinAction = UIAlertAction(title: "Notify Me Half An Hour Before", style: .default) { (action) in self.alertControllerActionHandler(offset: 30, event: event!) }
                let oneHourAction = UIAlertAction(title: "Notify Me 1 Hour Before", style: .default) { (action) in  self.alertControllerActionHandler(offset: 60, event: event!) }
                let twoHourAction = UIAlertAction(title: "Notify Me 2 Hours Before", style: .default) { (action) in self.alertControllerActionHandler(offset: 120, event: event!) }
                actions = [thirtyMinAction, oneHourAction, twoHourAction]
                
            } else {
                title = "Error adding event to your calendar"
                message = "We're having a hard time adding this event to yout calendar. Do us a favor and check settings to see if the app has permission to access your calendar"
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach() { alertController.addAction($0) }
            alertController.addAction(UIAlertAction(title: "Sounds Good!", style: .default, handler: nil))
            alertController.show()
        }
    }
    
    private func alertControllerActionHandler(offset: Int, event: Event) {
        self.viewModel.scheduleNotificationFromEvent(events: [event], negativeOffsetInMinutes: offset)
    }
}

