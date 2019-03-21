//
//  CalendarView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    
    private var viewModel = CalendarScreenViewModel()
    let cellSpacingHeight: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateFrames(frame: frame)
        self.addSubview(label)
        self.addSubview(card)
        card.addSubview(calendarListTableView)
    }
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Code that Cares"
        label.font = label.font.withSize(40)
        return label
    }()
    private lazy var card: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        return view
    }()
    private lazy var calendarListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 5
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    public func updateFrames(frame: CGRect){
        self.frame = frame
        label.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: label.intrinsicContentSize.height)
        card.frame =  CGRect(x: 10, y: label.frame.maxY + 20, width: frame.width - 20, height: frame.height - card.frame.origin.y - 30)
        calendarListTableView.frame = CGRect(x: 0, y: 0, width: card.frame.width, height: card.frame.height)
        self.setNeedsDisplay()
        label.setNeedsDisplay()
        card.setNeedsDisplay()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
        cell.title = "Whiteboard Coding!"
        cell.day = "21"
        cell.month = "January"
        cell.time = "6:00 PM"
        cell.detail = "Test your coding ability while practicing valuable skills for interviews."
        cell.location = "Enarson 245"
        return cell
    }
}
