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
        
        let label = UILabel(frame: CGRect(x: 10, y: 125, width: frame.width - 20, height: 75))
        label.text = "Code that Cares"
        label.font = label.font.withSize(40)
        self.addSubview(label)
        
        // 10 pt margin on both sides
        // y: label.frame.y + label.frame.height + 10 pt margin
        // height: frame.height - card.frame.y - 65 pt margin
        let card = UIView(frame: CGRect(x: 10, y: 210, width: frame.width - 20, height: frame.height - 275))
        card.backgroundColor = .white
        card.layer.cornerRadius = 5
        self.addSubview(card)
        
        let calendarListTableView = UITableView(frame: CGRect(x: 0, y: 0, width: card.frame.width, height: card.frame.height))
        calendarListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        calendarListTableView.backgroundColor = .white
        calendarListTableView.layer.cornerRadius = 5
        calendarListTableView.delegate = self
        calendarListTableView.dataSource = self
        card.addSubview(calendarListTableView)
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
