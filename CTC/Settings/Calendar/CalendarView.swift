//
//  CalendarView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class CalendarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let events: NSArray = ["Hackathon", "General Meeting", "Android Production", "MVVM", "Snapchat Case Study", "General Meeting", "Club Social", "Company Network"]
    
    private let dates: NSArray = ["4/1/19", "2/1/19", "2/2/19", "2/5/19", "2/6/19", "2/8/19", "2/10/19", "2/12/19"]
    
    private let times: NSArray = ["9:00am", "6:00pm", "5:00pm", "6:00pm", "7:00pm", "6:00pm", "9:00pm", "10:30am"]
    
    private let length: NSArray = ["24:00", "1:00", "2:00", "1:00", "2:00", "1:00", "48:00", "1:30"]
    
    private let location: NSArray = ["Ohio Union", "Enarson 480", "Caldwell 117", "Independence 200", "McPherson 256", "Enarson 480", "Annex", "Hitchcock Lobby"]

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
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let cell = EventCell(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100), title: events[indexPath.row] as! String, date: dates[indexPath.row] as! String, location: location[indexPath.row] as! String, time: times[indexPath.row] as! String, length: length[indexPath.row] as! String)
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EventCell: UITableViewCell {
    var cellAddButton: UIButton!
    var cellTitle: UILabel!
    var cellDate: UILabel!
    var cellTime: UILabel!
    var cellLength: UILabel!
    var cellLocation: UILabel!
    
    init(frame: CGRect, title: String, date: String, location: String, time: String, length: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cellTitle = UILabel(frame: CGRect(x: 5, y: 15, width: frame.width/1.5, height: frame.height/3 - 5))
        cellTitle.text = title
        cellTitle.font = cellTitle.font.withSize(20)
        addSubview(cellTitle)
        
        cellDate = UILabel(frame: CGRect(x: 5, y: frame.height / 3 + 10, width: frame.width/4, height: frame.height/3 - 10))
        cellDate.text = date
        addSubview(cellDate)
        
        cellLocation = UILabel(frame: CGRect(x: cellDate.intrinsicContentSize.width + 2, y: frame.height / 3 + 10, width: frame.width/2, height: frame.height/3 - 10))
        cellLocation.text = "  - " + location
        addSubview(cellLocation)
        
        cellTime = UILabel(frame: CGRect(x: 5, y: frame.height * 2 / 3, width: frame.width/2, height: frame.height/3))
        cellTime.text = time
        addSubview(cellTime)
        
        cellLength = UILabel(frame: CGRect(x: cellTime.intrinsicContentSize.width + 2, y: frame.height * 2 / 3, width: frame.width/2, height: frame.height/3))
        cellLength.text = "  - " + length
        addSubview(cellLength)
        
        // add to calendar is not mvp
//        cellAddButton = UIButton(frame: CGRect(x: frame.width - 25, y: frame.height/2 - 10, width: 20, height: 20))
//        cellAddButton.setTitle("+", for: .normal)
//        addSubview(cellAddButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
