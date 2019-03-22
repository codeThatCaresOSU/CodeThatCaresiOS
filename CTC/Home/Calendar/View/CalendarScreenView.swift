//
//  CalendarView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import EventKit

class CalendarView: UIView {
    
    private var viewModel = CalendarScreenViewModel()
    private let cellSpacingHeight: CGFloat = 10
    private let store = EKEventStore()
    private var events: [Event]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewModel.getAllEvents(){(events:[Event]) in
            self.events = events
            self.calendarListTableView.reloadData()
        }
        updateFrames(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(calendarListTableView)
    }
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming Events"
        label.font = UIFont.boldSystemFont(ofSize: 40)
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
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    public func updateFrames(frame: CGRect){
        self.frame = frame
        titleLabel.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: titleLabel.intrinsicContentSize.height)
        calendarListTableView.frame =  CGRect(x: 10, y: titleLabel.frame.maxY + 20, width: frame.width - 20, height: frame.height - calendarListTableView.frame.origin.y - 30)
        self.setNeedsDisplay()
        titleLabel.setNeedsDisplay()
        calendarListTableView.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.eventCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
        cell.cellCalendarDelegate = self
        cell.event = events![indexPath.section]
        return cell
    }
}
extension CalendarView: calendarDelegate {
    func addToCalendar(title: String, eventStartDate: Date, eventEndDate: Date, location: String, detail: String) {
        store.requestAccess(to: .event) { (success, error) in
            var alertTitle = "Error"
            var alertMessage = "Unkown error adding event to calendar."
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents // this will return deafult calendar from device calendars
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                event.location = location
                event.notes = detail
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    alertTitle = "Success!"
                    alertMessage = "Successfully added event to calendar!"
                } catch let error as NSError {
                    print("Failed to add event with error: \(error)")
                }

            } else {
                //we have error in getting access to device calnedar
                alertTitle = "Error"
                alertMessage = "Error accessing calendar."
            }
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alertController.show()
            }
        }
    }
}
// Utility for presenting alert
extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
}
