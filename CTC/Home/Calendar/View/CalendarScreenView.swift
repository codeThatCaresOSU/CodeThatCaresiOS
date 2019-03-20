//
//  CalendarView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class CalendarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModel = CalendarScreenViewModel()

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
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    private lazy var calendarListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 5
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Calendar Cell: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.eventCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let cell = EventCell(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100), title: self.viewModel.events?[indexPath.row].title as! String, date: self.viewModel.events?[indexPath.row].date as! String, location: self.viewModel.events?[indexPath.row].location as! String, time: self.viewModel.events?[indexPath.row].time as! String, length: self.viewModel.events?[indexPath.row].length as! String)
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
