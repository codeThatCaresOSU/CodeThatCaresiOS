//
//  SettingsScreenView.swift
//  CTC
//
//  Created by Tyler Stohr on 3/5/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class SettingsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModel = SettingsScreenViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 10, y: 125, width: frame.width - 20, height: 75))
        label.text = "Settings"
        label.font = label.font.withSize(40)
        self.addSubview(label)
        
        // 10 pt margin on both sides
        // y: label.frame.y + label.frame.height + 10 pt margin
        // height: frame.height - card.frame.y - 65 pt margin
        let card = UIView(frame: CGRect(x: 10, y: 210, width: frame.width - 20, height: frame.height - 275))
        card.backgroundColor = .white
        card.layer.cornerRadius = 5
        //self.addSubview(card)
        
        let calendarListTableView = UITableView(frame: CGRect(x: 0, y: 0, width: card.frame.width, height: card.frame.height))
        calendarListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        calendarListTableView.backgroundColor = .white
        calendarListTableView.layer.cornerRadius = 5
        calendarListTableView.delegate = self
        calendarListTableView.dataSource = self
        //card.addSubview(calendarListTableView)
        
        let replayCard = UIView(frame: CGRect(x: 10, y: 210, width: frame.width - 20, height: 100))
        replayCard.layer.cornerRadius = 10
        replayCard.backgroundColor = .white
        
        let gradientView = UIView(frame: CGRect(x: 10, y: 10, width: replayCard.frame.width - 20, height: replayCard.frame.height - 20))
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        let colorLeft = UIColor(red: 140.0 / 255.0, green: 196.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0).cgColor
        //let colorLeft = UIColor(red: 255.0 / 255.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0).cgColor
        let colorRight = UIColor(red: 0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
        // Gradient from left to right
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.locations = [0.0, 1.0]
        
        let replayLabel = UILabel(frame: CGRect(x: 10, y: 0, width: replayCard.frame.width - 20, height: replayCard.frame.height - 20))
        replayLabel.text = "Replay Intro  >"
        replayLabel.font = UIFont(name: "AdventPro-SemiBold", size: 60)
        
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.addSubview(replayLabel)
        gradientView.mask = replayLabel
        replayCard.addSubview(gradientView)
        self.addSubview(replayCard)
        
        let notificationCard = UIView(frame: CGRect(x: 10, y: 350, width: frame.width - 20, height: frame.height - 700))
        notificationCard.layer.cornerRadius = 10
        notificationCard.backgroundColor = .white
        
        let notificationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: notificationCard.frame.width - 10, height: 30))
        notificationLabel.text = "Notifications"
        notificationLabel.font = UIFont(name: "AdventPro-SemiBold", size: 20)
        
        let allSwitchView = UIView(frame: CGRect(x: 20, y: 50, width: notificationCard.frame.width - 20, height: 50))
        let allLabel = UILabel(frame: CGRect(x: 0, y: 0, width: allSwitchView.frame.width / 2 - 10, height: 50))
        allLabel.text = "All"
        allLabel.font = UIFont(name: "AdventPro-SemiBold", size: 18)
        
        let allSwitch = UISwitch(frame: CGRect(x: allSwitchView.frame.width - 80, y: 0, width: allSwitchView.frame.width / 2, height: 50))
        
        allSwitchView.addSubview(allLabel)
        allSwitchView.addSubview(allSwitch)
        notificationCard.addSubview(notificationLabel)
        notificationCard.addSubview(allSwitchView)
        self.addSubview(notificationCard)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let title = UILabel()
        title.text = viewModel.title[indexPath.row]
        print(viewModel.title[indexPath.row])
        cell.addSubview(title)
        
        return cell
    }
    
    
}
